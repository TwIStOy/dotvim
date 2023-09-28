local FD_CMD = { "fd", "--no-ignore", "-e", "md" }
local Globals = require("ht.core.globals")
local entry_display = require("telescope.pickers.entry_display")
local obsidian = require("obsidian")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")
local finders = require("telescope.finders")
assert(obsidian ~= nil)

local function all_notes_with_metadata()
  local handle = vim
    .system(FD_CMD, {
      cwd = Globals.obsidian_vault,
      text = true,
    })
    :wait()
  assert(handle.code == 0)
  local lines = vim.split(handle.stdout, "\n", {
    trimempty = true,
  })
  local ret = {}
  for _, line in ipairs(lines) do
    if line:find("1-Inputs/Weread") == nil then
      local note = obsidian.note.from_file(
        Globals.obsidian_vault .. "/" .. line,
        Globals.obsidian_vault
      )
      local item = {
        aliases = note.aliases,
        path = line,
        tags = note.tags,
        id = note.id,
      }
      ret[#ret + 1] = item
    end
  end
  return ret
end

---@param opts table
---@return function
local function entry_maker(opts, id_width, title_width)
  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = id_width, right_justify = true },
      { width = title_width },
    },
  }

  local function make_display(entry)
    return displayer {
      { entry.value.id, "@variable.builtin" },
      entry.value.title,
    }
  end

  return function(entry)
    return {
      value = entry,
      display = make_display,
      ordinal = entry.title,
    }
  end
end

---@param opts table
---@return function
local function tag_entry_maker(opts, tag_width)
  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = 5, right_justify = true },
      { width = tag_width },
    },
  }

  local function make_display(entry)
    return displayer {
      #entry.value.notes,
      { entry.value.tag, "@variable.builtin" },
    }
  end

  return function(entry)
    return {
      value = entry,
      display = make_display,
      ordinal = entry.tag,
    }
  end
end

local function find_notes(opts, notes)
  local title_width = 0
  local id_width = 0
  local values = {}
  for _, note in ipairs(notes) do
    for _, alias in ipairs(note.aliases) do
      if #alias > title_width then
        title_width = #alias
      end
      values[#values + 1] = {
        title = alias,
        id = note.id,
        path = note.path,
      }
    end
    if #note.id > id_width then
      id_width = #note.id
    end
  end

  pickers
    .new(opts, {
      prompt_title = "Obsidian Notes",
      sorter = conf.generic_sorter(opts),
      finder = finders.new_table {
        results = values,
        entry_maker = entry_maker(opts, id_width, title_width),
      },
      previewer = false,
      attach_mappings = function(bufnr, map)
        map("i", "<CR>", function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry ~= nil then
            local value = entry.value
            vim.cmd(("e %s/%s"):format(Globals.obsidian_vault, value.path))
          end
        end)
        return true
      end,
    })
    :find()
end

local function find_notes_alias(opts)
  local notes = all_notes_with_metadata()
  find_notes(opts, notes)
end

local function find_notes_tags(opts, inner_opts)
  local notes = all_notes_with_metadata()
  local tag_width = 0
  local tags = {}
  for _, note in ipairs(notes) do
    for _, tag in ipairs(note.tags) do
      if #tag > tag_width then
        tag_width = #tag
      end
      if tags[tag] == nil then
        tags[tag] = {}
      end
      table.insert(tags[tag], note)
    end
  end
  local values = {}
  for tag, _notes in pairs(tags) do
    values[#values + 1] = {
      tag = tag,
      notes = _notes,
    }
  end

  pickers
    .new(opts, {
      prompt_title = "Obsidian Tags",
      sorter = conf.generic_sorter(opts),
      finder = finders.new_table {
        results = values,
        entry_maker = tag_entry_maker(opts, tag_width),
      },
      previewer = false,
      attach_mappings = function(bufnr, map)
        map("i", "<CR>", function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry ~= nil then
            local value = entry.value
            find_notes(inner_opts, value.notes)
          end
        end)
        return true
      end,
    })
    :find()
end

return telescope.register_extension {
  exports = {
    find_notes_by_alias = find_notes_alias,
    find_notes_by_tags = find_notes_tags,
  },
}
