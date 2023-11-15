import { MenuItem, MenuItemContext } from "./menu-item";

interface DisplayOptions {
  init_winnr: number;
  row: number;
  col: number;
}

interface ContextMenuProps {
  parent?: ContextMenu;
  display_options: DisplayOptions;
}

const defaultPopupOptions: NuiPopupOptions = {
  relative: { type: "win" },
  focusable: false,
  buf_options: {
    modifiable: false,
    readonly: true,
    filetype: "rightclickpopup",
  },
  zindex: 210,
  border: {
    style: "single",
    padding: { top: 0, bottom: 0, left: 1, right: 1 },
  },
  win_options: {
    winblend: 0,
    winhighlight:
      "NormalSB:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine",
  },
};

const defaultMenuOptions: NuiMenuOptions<MenuItemContext> = {
  min_width: 20,
  max_width: 120,
  keymap: {
    focus_next: ["j", "<DOWN>", "<C-n>", "<TAB>"],
    focus_prev: ["k", "<UP>", "<C-p>", "<S-TAB>"],
    close: ["<ESC>", "<C-c>", "q"],
    submit: ["<CR>"],
  },
  on_change: (item, menu) => {
    let props = menu.menu_props;

    item.parent = props.get("instance");
    print(item.menuItem.description ?? "\n\n");
  },
  /*
  *
  on_change = function(item, menu)
    ---@type MenuItem
    local menu_context = menu.menu_props.menu_context
    if menu_context.keymaps == nil then
      for linenr = 1, #menu.tree.nodes.root_ids do
        local node, target_linenr = menu.tree:get_node(linenr)
        if not menu._.should_skip_item(node) then
          ---@type MenuItem
          local menu_item = node.menu_item

          for key, v in pairs(menu_item.keys) do
            if v then
              menu:map("n", key, function()
                vim.api.nvim_win_set_cursor(menu.winid, { target_linenr, 0 })
                menu._.on_change(node)
                if menu_item.children ~= nil and #menu_item.children > 0 then
                  -- expand
                  on_expand(node, menu)
                else
                  -- submit
                  menu.menu_props.on_submit(node)
                end
              end, { noremap = true, nowait = true })
            end
          end
        end
      end
      menu_context.keymaps = true
    end

    ---@type MenuItem
    local menu_item = item.menu_item

    item.menu_item.in_menu = menu
    if menu_item.desc ~= nil then
      print(menu_item.desc)
    else
      print("\n\n")
    end
  end,
  on_submit = function(item)
    ---@type MenuItem
    local menu_item = item.menu_item
    local menu = menu_item.in_menu
    local menu_context = menu.menu_props.menu_context

    -- close all previous menus
    local parent = menu_context.parent
    while parent ~= nil do
      parent:unmount()
      parent = parent.menu_props.menu_context.parent
    end

    vim.api.nvim_set_current_win(menu_context.display_options.init_winnr)

    if menu_item.callback ~= nil then
      menu_item.callback()
    end
  end,
  */
  on_submit: (item) => {},
};

function findItemInMenu<T>(item: NuiTreeNode<T>, menu: NuiMenu<T>) {
  for (const [i, val] of menu.tree.nodes.root_ids.entries()) {
    if (val === item.get_id()) {
      return i;
    }
  }
  return undefined;
}

function onExpand(
  item: NuiTreeNode<MenuItemContext>,
  menu: NuiMenu<MenuItemContext>
) {
  let pos = findItemInMenu(item, menu);
  let menu_context = menu.menu_props.get("menu_context");

  let displayOptions: DisplayOptions = {
    init_winnr: menu_context.display_options.init_winnr,
    row: menu_context.display_options.row + pos - 1,
    col: menu_context.display_options.col + menu.win_config.width + 4,
  };
  let children = item.menuItem?.children || [];
  let contextMenu = new ContextMenu(children);
  contextMenu.asNuiMenu(displayOptions as any, menu as any).mount();
}

function initializeOptions(): DisplayOptions {
  let firstLine = vim.fn.line("w0");
  let [r, c] = vim.api.nvim_win_get_cursor(0);
  let winnr = vim.api.nvim_get_current_win();
  r = r - firstLine + 2;
  c = c + 8;
  return { init_winnr: winnr, row: r, col: c };
}

export class ContextMenu {
  public items: MenuItem[];

  constructor(items: MenuItem[]) {
    this.items = items;
  }

  asNuiMenu(
    menu: NuiMenuOptions<MenuItemContext>,
    opts?: DisplayOptions
  ): NuiMenu<MenuItemContext> {
    if (!opts) {
      opts = initializeOptions();
    }

    return nil;
  }
}
