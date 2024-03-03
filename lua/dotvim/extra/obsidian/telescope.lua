---@class dotvim.extra.obsidian.telescope
local M = {}

---@param _ any
---@param base_path Path
local function note_entry_maker(_, base_path)
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = 9,       right_justify = true },
      { remaining = true },
    },
  }

  local function display_entry(entry)
    ---@type dotvim.extra.obsidian.ObsidianNote
    local note = entry.value.note
    local links = #note.cachedMetadata.links
    local backlinks = note.cachedMetadata.backlinks_count
    local links_part = ("󱣾 %2d 󰌹 %2d"):format(backlinks, links)
    local title = note:title()

    return displayer {
      { links_part, "@variable.builtin" },
      title,
    }
  end

  ---@param note dotvim.extra.obsidian.ObsidianNote
  return function(note)
    local entry = {
      note = note,
      title = note:title(),
      path = tostring(base_path / note.path),
    }
    return {
      value = entry,
      ordinal = entry.title,
      display = display_entry,
      path = entry.path,
    }
  end
end

---@param _ any
local function tag_entry_maker(_)
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = 5,       right_justify = true },
      { remaining = true },
    },
  }

  local function display_entry(entry)
    ---@type dotvim.extra.obsidian.ObsidianNote[]
    local notes = entry.value.notes

    return displayer {
      { #notes, "@variable.builtin" },
      entry.value.tag,
    }
  end

  return function(entry)
    return {
      value = entry,
      ordinal = entry.tag,
      display = display_entry,
    }
  end
end

---@param opts table
---@param notes dotvim.extra.obsidian.ObsidianNote[]
---@param base_path Path
local function notes_picker(opts, notes, base_path)
  opts = opts or {}
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  pickers
      .new(opts, {
        prompt_title = "Obsidian Notes",
        sorter = conf.generic_sorter(opts),
        finder = finders.new_table {
          results = notes,
          entry_maker = note_entry_maker(opts, base_path),
        },
        previewer = conf.file_previewer(opts),
        attach_mappings = function(bufnr, map)
          map("i", "<CR>", function()
            local entry = action_state.get_selected_entry()
            actions.close(bufnr)
            if entry ~= nil then
              vim.cmd(("e %s"):format(entry.path))
            end
          end)
          return true
        end,
      })
      :find()
end

local note_path_blacklist_pattern = {
  "1-Inputs/Weread",
  "0-Assets",
}

---@param path string
local function is_blacklisted(path)
  for _, pattern in ipairs(note_path_blacklist_pattern) do
    if path:find(pattern, 1, true) then
      return true
    end
  end
  return false
end

function M.find_notes_alias(opts)
  ---@type dotvim.extra.obsidian.graphql
  local graphql = require("dotvim.extra.obsidian.graphql")
  local Path = require("plenary.path")
  local base_path, input_notes = graphql.get_all_markdown_files()
  local notes = {}
  for _, note in ipairs(input_notes) do
    if not is_blacklisted(note.path) then
      table.insert(notes, note)
    end
  end
  notes_picker(opts, notes, Path:new(base_path))
end

function M.find_notes_tags(opts, next_opts)
  ---@type dotvim.extra.obsidian.graphql
  local graphql = require("dotvim.extra.obsidian.graphql")
  local Path = require("plenary.path")
  local base_path, input_notes = graphql.get_all_markdown_files()
  base_path = Path:new(base_path)

  local tags = {}
  for _, note in ipairs(input_notes) do
    if is_blacklisted(note.path) then
      goto continue
    end

    for _, tag in ipairs(note:tags()) do
      if tags[tag] == nil then
        tags[tag] = {
          tag = tag,
          notes = {},
          base_path = base_path,
        }
      end
      table.insert(tags[tag].notes, note)
    end
    ::continue::
  end

  local values = {}
  for _, tag in pairs(tags) do
    table.insert(values, tag)
  end

  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  opts = opts or {}

  pickers
      .new(opts, {
        prompt_title = "Obsidian Tags",
        sorter = conf.generic_sorter(opts),
        finder = finders.new_table {
          results = values,
          entry_maker = tag_entry_maker(opts),
        },
        previewer = false,
        attach_mappings = function(bufnr, map)
          map("i", "<CR>", function()
            local entry = action_state.get_selected_entry()
            actions.close(bufnr)
            if entry ~= nil then
              local value = entry.value
              notes_picker(next_opts, value.notes, value.base_path)
            end
          end)
          return true
        end,
      })
      :find()
end

return M
