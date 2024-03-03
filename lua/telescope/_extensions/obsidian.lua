local Globals = require("ht.core.globals")
local entry_display = require("telescope.pickers.entry_display")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")
local finders = require("telescope.finders")
local extra_obsidian = require("ht.extra.obsidian")
local Tbl = require("ht.utils.table")
local hv = require("ht.vim")

local note_path_blacklist_pattern = {
  "1-Inputs/Weread",
  "0-Assets",
}

---@return ObsidianNote[]
local function filter_out_notes()
  local all_notes = extra_obsidian.get_all_markdown_files()
  local ret = {}
  for _, note in ipairs(all_notes) do
    local skip = false
    for _, pattern in ipairs(note_path_blacklist_pattern) do
      if note.path:find(pattern) ~= nil then
        skip = true
        break
      end
    end
    if not skip then
      ret[#ret + 1] = note
    end
  end
  return ret
end

---@class ObsidianEntry
---@field value ObsidianNote
---@field title string

---@param opts table
---@param link_count_width number
---@param id_width number
---@param title_width number
---@return function
local function entry_maker(opts, link_count_width, id_width, title_width)
  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = link_count_width, right_justify = true },
      { width = id_width,         right_justify = true },
      { width = title_width },
    },
  }

  local function make_display(entry)
    return displayer {
      { entry.value.value:link_count(), "Comment" },
      { entry.value.value:id(),         "@variable.builtin" },
      entry.value.title,
    }
  end

  ---@param entry ObsidianEntry
  return function(entry)
    return {
      value = entry,
      ordinal = entry.title,
      display = make_display,
      path = Globals.obsidian_vault .. "/" .. entry.value.path,
    }
  end
end

---@param opts table
---@return function
local function tag_entry_maker(opts, tag_width)
  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = 5,        right_justify = true },
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

---@param notes ObsidianNote[]
local function find_notes(opts, notes)
  local id_width = Tbl.reduce_with(notes, function(note)
    return #hv.if_nil(note:id(), "")
  end, math.max, 0)
  local title_width = Tbl.reduce_with(notes, function(note)
    return Tbl.reduce_with(note:aliases(), function(s)
      return #s
    end, math.max, 0)
  end, math.max, 0)
  local link_count_width = Tbl.reduce_with(notes, function(note)
    return #note:link_count()
  end, math.max, 0)

  ---@type ObsidianEntry[]
  local entries = {}
  for _, note in ipairs(notes) do
    for _, alias in ipairs(note:aliases()) do
      if #alias > title_width then
        title_width = #alias
      end
      entries[#entries + 1] = {
        id = note:id(),
        value = note,
        title = alias,
      }
    end
  end
  if id_width > 35 then
    id_width = 35
  end

  pickers
      .new(opts, {
        prompt_title = "Obsidian Notes",
        sorter = conf.generic_sorter(opts),
        finder = finders.new_table {
          results = entries,
          entry_maker = entry_maker(
            opts,
            link_count_width,
            id_width,
            title_width
          ),
        },
        previewer = conf.file_previewer(opts),
        attach_mappings = function(bufnr, map)
          map("i", "<CR>", function()
            local entry = action_state.get_selected_entry()
            actions.close(bufnr)
            if entry ~= nil then
              vim.cmd(
                ("e %s/%s"):format(Globals.obsidian_vault, entry.value.value.path)
              )
            end
          end)
          return true
        end,
      })
      :find()
end

local function find_notes_alias(opts)
  local notes = filter_out_notes()
  find_notes(opts, notes)
end

local function find_notes_tags(opts, inner_opts)
  local notes = filter_out_notes()
  local tag_width = Tbl.reduce_with(notes, function(note)
    return Tbl.reduce_with(note:tags(), function(s)
      return #s
    end, math.max, 0)
  end, math.max, 0)

  local tags = {}
  for _, note in ipairs(notes) do
    for _, tag in ipairs(note:tags()) do
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
