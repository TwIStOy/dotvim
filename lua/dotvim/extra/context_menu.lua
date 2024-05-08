---@class dotvim.extra.context_menu
local M = {}

local new_item = require("dotvim.extra.ui.context_menu.item")
---@type dotvim.extra.ui.context_menu.ContextMenu
local ContextMenu = require("dotvim.extra.ui.context_menu.menu")

---@return dotvim.extra.ui.context_menu.MenuItem[]
local function build_nodes()
  local expand_binding =
    require("refactor.actions.nix").expand_binding.create_context()

  return {
    new_item {
      text = "󰘖  Expand Binding",
      callback = function()
        expand_binding.do_refactor()
      end,
      disabled = not expand_binding.available(),
    },
  }
end

M.open_context_menu = function()
  local menu = ContextMenu.construct()
  menu:init(build_nodes())
  menu:mount(true)
end

return M
