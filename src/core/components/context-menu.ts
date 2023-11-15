import { NuiMenuMod } from "@extra/nui";
import { MenuItem, MenuItemContext } from "./menu-item";
import { tblExtend } from "@core/vim_wrapper";

interface DisplayOptions {
  init_winnr: number;
  row: number;
  col: number;
}

function initializeOptions(): DisplayOptions {
  let firstLine = vim.fn.line("w0");
  let [r, c] = vim.api.nvim_win_get_cursor(0);
  let winnr = vim.api.nvim_get_current_win();
  r = r - firstLine + 2;
  c = c + 8;
  return { init_winnr: winnr, row: r, col: c };
}

export interface ContextMenuContext {
  displayOptions: DisplayOptions;
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

function findItemInMenu<T>(
  item: NuiTreeNode<T>,
  menu: NuiMenu<T, ContextMenuContext>
) {
  for (const [i, val] of menu.tree.nodes.root_ids.entries()) {
    if (val === item.get_id()) {
      return i;
    }
  }
  return undefined;
}

function onExpand(
  item: NuiTreeNode<MenuItemContext>,
  menu: NuiMenu<MenuItemContext, ContextMenuContext>
) {
  let pos = findItemInMenu(item, menu);
  let menuContext = menu.menu_props.context;

  let displayOptions: DisplayOptions = {
    init_winnr: menuContext!.displayOptions.init_winnr,
    row: menuContext!.displayOptions.row + pos! - 1,
    col: menuContext!.displayOptions.col + menu.win_config.width + 4,
  };
  let children = item.menuItem?.children || [];
  let contextMenu = new ContextMenu(children);
  contextMenu.mount(displayOptions, menu);
}

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
    let menu_context = props.get("menu_context");

    if (menu_context.keymaps === null) {
      for (let linenr = 1; linenr < menu.tree.nodes.root_ids.length; linenr++) {
        let [node, targetLinenr] = menu.tree.get_node(linenr);
        if (!node || targetLinenr === null) {
          continue;
        }
        if (!menu._.should_skip_item(node)) {
          let menuItem = node.menuItem;
          for (let key in menuItem.keys) {
            menu.map(
              "n",
              key,
              () => {
                vim.api.nvim_win_set_cursor(menu.winid, [targetLinenr!, 0]);
                menu._.on_change(node!);
                if (menuItem.children && menuItem.children.length > 0) {
                  onExpand(node!, menu);
                } else {
                  menu.menu_props.on_submit();
                }
              },
              { noremap: true, nowait: true }
            );
          }
        }
      }
      menu_context.keymaps = true;
    }

    item.menuItem.parent = menu;
    print(item.menuItem.description ?? "\n\n");
  },
  /*
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
  on_submit: (item) => {
    let menuItem = item.menuItem;
    let menu = menuItem.parent;
    let menuContext = menu?.menu_props.get("menu_context");
  },
};

export class ContextMenu {
  public items: MenuItem[];
  public parent?: ContextMenu;
  public rendered?: boolean;

  constructor(items: MenuItem[]) {
    this.items = items;
  }

  mount(displayOptions: DisplayOptions, parent?: NuiMenu<MenuItemContext>) {}

  asNuiMenu(
    opts: DisplayOptions
    // menuOptions: NuiMenuOptions<MenuItemContext>,
  ): NuiMenu<MenuItemContext> {
    if (!opts) {
      opts = initializeOptions();
    }

    let popupOptions: NuiPopupOptions = tblExtend(
      "force",
      defaultPopupOptions,
      {
        position: { row: opts.row, col: opts.col },
        relative: { winid: opts.init_winnr, type: "win" },
      }
    );

    if (this.parent) {
      popupOptions.zindex =
        this.parent.asNuiMenu(menuOptions).win_config.zindex;
    }

    let ret = NuiMenuMod.newMenu(popupOptions, menuOptions);

    return ret;
  }
}
