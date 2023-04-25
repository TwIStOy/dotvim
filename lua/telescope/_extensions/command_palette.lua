local telescope = require('telescope')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local utils = require "telescope.utils"

---@param opts table
---@return function
local function entry_maker(opts, category_width, title_width)
  ---@param entry FunctionWithDescription
  return function(entry)
    local category = entry.category or ""
    local category_padding = string.rep(" ", category_width - #category)

    return {
      value = entry,
      display = category_padding .. category .. ' | ' .. entry.title,
      ordinal = entry.title,
    }
  end
end

local function open_command_palette(opts)
  local ft = vim.bo.filetype
  local filename = vim.fn.expand('%:t')

  local functions, category_width, title_width =
      require('ht.core.functions'):get_functions(ft, filename)
  pickers.new(opts, {
    prompt_title = 'Command Palette',
    sorter = conf.generic_sorter(opts),
    finder = finders.new_table {
      results = functions,
      entry_maker = entry_maker(opts, category_width, title_width),
    },
    previewer = false,
    attach_mappings = function(bufnr, map)
      map('i', '<CR>', function()
        local entry = action_state.get_selected_entry()
        actions.close(bufnr)
        ---@type FunctionWithDescription
        local value = entry.value
        value.f()
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension {
  exports = { command_palette = open_command_palette },
}
