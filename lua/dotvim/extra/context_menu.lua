---@class dotvim.extra.context_menu
local M = {}

---@type dotvim.extra.context_menus.groups
local Groups = require("dotvim.extra.context_menus.groups")

---@type dotvim.extra.context_menus.utils
local Utils = require("dotvim.extra.context_menus.utils")

---@return dotvim.extra.ContextMenuOptions
local function build_nodes()
  return {
    Groups.build_plugin_refactor(),
  }
end

M.open_context_menu = function()
  local nodes = {}
  for _, node in ipairs(build_nodes()) do
    if Utils.option_should_display(node) then
      nodes[#nodes + 1] = node
    end
  end

  if #nodes == 0 then
    print("No context menu items to display")
    return
  end

  require("menu").open(nodes)
end

return M
