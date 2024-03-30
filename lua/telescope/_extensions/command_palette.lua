local telescope = require("telescope")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")

---@return function
local function entry_maker(_, category_width, title_width)
  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = category_width, right_justify = true },
      { width = title_width },
    },
  }

  local function make_display(entry)
    return displayer {
      { entry.value.category, "@variable.builtin" },
      entry.value.title,
    }
  end

  ---@param entry dotvim.core.action.Action
  return function(entry)
    local category = entry.category or ""
    entry.category = category

    return {
      value = entry,
      display = make_display,
      ordinal = category .. entry.title,
    }
  end
end

---@type dotvim.core
local Core = require("dotvim.core")

---@type dotvim.utils
local Utils = require("dotvim.utils")

local function open_command_palette(opts)
  local buffer = Core.vim.wrap_buffer(vim.api.nvim_get_current_buf())
  local buf_actions = Core.registry.buf_get_all_actions(buffer)

  local category_width = math.min(
    Utils.tbl.reduce_left(
      buf_actions,
      0,
      ---@param acc number
      ---@param action dotvim.core.action.Action
      function(acc, action)
        return math.max(acc, action:category_length())
      end
    ),
    20
  )
  local title_width = Utils.tbl.reduce_left(
    buf_actions,
    0,
    ---@param acc number
    ---@param action dotvim.core.action.Action
    function(acc, action)
      return math.max(acc, #action.title)
    end
  )

  pickers
    .new(opts, {
      prompt_title = "Command Palette",
      sorter = conf.generic_sorter(opts),
      finder = finders.new_table {
        results = buf_actions,
        entry_maker = entry_maker(opts, category_width, title_width),
      },
      previewer = false,
      attach_mappings = function(bufnr, map)
        map("i", "<CR>", function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry ~= nil then
            local value = entry.value
            value:execute()
          end
        end)
        return true
      end,
    })
    :find()
end

---@diagnostic disable-next-line: undefined-field
return telescope.register_extension {
  exports = { command_palette = open_command_palette },
}
