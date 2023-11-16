import { NuiMenuMod } from "@extra/nui";
import { MenuItem, MenuItemContext } from "./menu-item";
import { tblExtend } from "@core/utils/table";

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
  parent?: NuiMenu<MenuItemContext, ContextMenuContext>;
  keymapSetup?: boolean;
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

function maxTextWidth(items: MenuItem[]) {
  let ret = 0;
  for (let item of items) {
    ret = Math.max(ret, item.length);
  }
  return Math.max(ret, 20);
}

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
  contextMenu.asNuiMenu({ displayOptions, parent: menu }).mount();
}

const defaultMenuOptions: Omit<
  NuiMenuOptions<MenuItemContext, ContextMenuContext>,
  "lines"
> = {
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
    let menuContext = props.context;

    if (
      menuContext?.keymapSetup === null ||
      menuContext?.keymapSetup === false
    ) {
      for (const linenr of $range(1, menu.tree.nodes.root_ids.length)) {
        let [node, targetLinenr] = menu.tree.get_node(linenr);
        if (!node || targetLinenr === null) {
          continue;
        }
        if (!menu._.should_skip_item(node)) {
          let menuItem = node.menuItem;
          for (let key of menuItem.keys) {
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
      menuContext.keymapSetup = true;
    }

    item.menuItem.parent = menu;
    print(item.menuItem.description ?? "\n\n");
  },
  on_submit: (item) => {
    let menuItem = item.menuItem;
    let menu = menuItem.parent;
    let menuContext = menu?.menu_props.context;

    let parent = menuContext?.parent;
    while (parent) {
      parent.unmount();
      parent = parent.menu_props.context?.parent;
    }

    vim.api.nvim_set_current_win(menuContext!.displayOptions.init_winnr);
    menuItem.callback();
  },
};

export class ContextMenu {
  public items: MenuItem[];
  public parent?: ContextMenu;
  public rendered?: boolean;

  constructor(items: MenuItem[]) {
    this.items = items;
  }

  asNuiMenu(opts: {
    displayOptions?: DisplayOptions;
    parent?: NuiMenu<MenuItemContext, ContextMenuContext>;
    // menuOptions: NuiMenuOptions<MenuItemContext>,
  }): NuiMenu<MenuItemContext, ContextMenuContext> {
    opts.displayOptions = initializeOptions();

    let popupOptions: NuiPopupOptions = tblExtend(
      "force",
      defaultPopupOptions,
      {
        position: {
          row: opts.displayOptions.row,
          col: opts.displayOptions.col,
        },
        relative: { winid: opts.displayOptions.init_winnr, type: "win" },
      }
    );
    if (opts.parent) {
      popupOptions.zindex = opts.parent?.win_config.zindex + 2;
    }

    let lines = [];
    let subTextWidth = maxTextWidth(this.items);
    for (let item of this.items) {
      lines.push(item.asNuiTreeNode(subTextWidth));
    }
    let menuOptions: NuiMenuOptions<MenuItemContext, ContextMenuContext> =
      tblExtend("force", defaultMenuOptions, {
        lines: lines,
        on_close: () => {
          if (opts.parent) {
            vim.api.nvim_set_current_win(opts.parent.winid);
          } else {
            vim.api.nvim_set_current_win(opts.displayOptions?.init_winnr!);
          }
        },
      });

    let ret = NuiMenuMod.newMenu(popupOptions, menuOptions);
    ret.menu_props.context = {
      displayOptions: opts.displayOptions,
      parent: opts.parent,
    };

    ret.map(
      "n",
      "h",
      () => {
        ret.menu_props.on_close();
      },
      { noremap: true, nowait: true }
    );
    ret.map(
      "n",
      "l",
      () => {
        let [item] = ret.tree.get_node();
        if (item) {
          let menuItem = item.menuItem;
          if (menuItem.children && menuItem.children.length > 0) {
            onExpand(item, ret);
          }
        }
      },
      { noremap: true, nowait: true }
    );

    return ret;
  }
}
