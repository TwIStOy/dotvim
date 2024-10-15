---@class dotvim.extra.context_menu
local M = {}

---@type dotvim.extra.context_menus.groups
local Groups = require("dotvim.extra.context_menus.groups")

---@type dotvim.extra.context_menus.utils
local Utils = require("dotvim.extra.context_menus.utils")

---@return dotvim.extra.ContextMenuOptions
local function build_nodes()
  return {
    {
      Groups.build_plugin_refactor(),
    },
    {
      Groups.build_plugin_rust_lsp(),
    },
    {
      Groups.build_plugin_harpoon(),
    }
  }
end

M.open_context_menu = function()
  local nodes = {}
  for _, node in ipairs(build_nodes()) do
    local group = {}
    for _, item in ipairs(node) do
      if Utils.option_should_display(item) then
        group[#group + 1] = item
      end
    end
    if #group > 0 then
      if #nodes > 0 then
        nodes[#nodes + 1] = { name = "separator" }
      end
      vim.list_extend(nodes, group)
    end
  end

  if #nodes == 0 then
    print("No context menu items to display")
    return
  end

  require("menu").open(nodes)
end

return M
