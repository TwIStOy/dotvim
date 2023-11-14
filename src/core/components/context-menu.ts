import { NuiTreeNodeContext } from "./menu-item";

function findItemInMenu<T>(item: NuiTreeNode<T>, menu: NuiMenu) {
  for (const [i, val] of menu.tree.nodes.root_ids.entries()) {
    if (val === item.get_id()) {
      return i;
    }
  }
  return undefined;
}

function onExpand(item: NuiTreeNode<NuiTreeNodeContext>, menu: NuiMenu) {
  let pos = findItemInMenu(item, menu);
}

/**
   ---@type MenuItem
  local menu_item = item.menu_item
  local menu_context = menu.menu_props.menu_context

  local pos = find_item_in_menu(item, menu)
  local display_options = {
    init_winnr = menu_context.display_options.init_winnr,
    row = menu_context.display_options.row + pos - 1,
    col = menu_context.display_options.col + menu.win_config.width + 4,
  }
  ---@type ContextMenu
  local context_menu = { items = {} }
  for _, child in ipairs(menu_item.children) do
    table.insert(context_menu.items, child)
  end
  setmetatable(context_menu, { __index = ContextMenu })

  local new_menu = context_menu:as_nui_menu(display_options, menu)
  new_menu:mount() 
  
  */
