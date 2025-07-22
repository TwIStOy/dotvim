---@type dotvim.core.registry
local Reg = require("dotvim.core.registry")
---@type dotvim.core.vim
local Vim = require("dotvim.core.vim")
---@type dotvim.utils
local Utils = require("dotvim.utils")

local actions = {}

---@param ctx dotvim.extra.search_everywhere.Context
function actions.new(ctx)
  local results = Reg.buf_get_all_actions(Vim.wrap_buffer(ctx.bufnr))

  local category_width = math.min(
    Utils.tbl.reduce_left(
      results,
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
    results,
    0,
    ---@param acc number
    ---@param action dotvim.core.action.Action
    function(acc, action)
      return math.max(acc, #action.title)
    end
  )

  local displayer = require("telescope.pickers.entry_display").create {
    separator = "  ",
    items = {
      { width = 9, right_justify = true },
      { width = category_width, right_justify = true },
      { width = title_width },
      { remaining = true },
    },
  }

  local entries = vim
    .iter(results)
    ---@param action dotvim.core.action.Action
    :map(function(action)
      ---@type dotvim.extra.search_everywhere.Entry
      return {
        filename = nil,
        kind = "Action",
        preview = "None",
        columns = {
          { action.category, "@variable.builtin" },
          action.title,
          action.description or "",
        },
        search_key = (action.category or "") .. action.title,
        displayer = displayer,
      }
    end)
    :totable()

  local self = setmetatable({
    thread = coroutine.create(function()
      return entries
    end),
  }, { __index = actions })

  return self
end

function actions:close() end

return {
  actions = actions,
}
