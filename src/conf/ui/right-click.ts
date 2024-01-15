import { AvailableActions } from "@conf/actions";
import { ActionRegistry } from "@conf/plugins";
import { ContextMenu } from "@core/components/context-menu";
import { MenuItem } from "@core/components/menu-item";
import { VimBuffer, isNil } from "@core/vim";

interface RightClickMenuItemBase {
  title: string;
  keys?: string | string[];
}

interface RightClickMenuActionItem extends RightClickMenuItemBase {
  actionId: AvailableActions;
  alwaysInMenu?: boolean;
}

interface RightClickMenuSubMenuItem extends RightClickMenuItemBase {
  children: RightClickMenuItem[];
}

interface RightClickMenuGroup {
  items: RightClickMenuItem[];
}

type RightClickMenuItem =
  | RightClickMenuActionItem
  | RightClickMenuSubMenuItem
  | RightClickMenuGroup;

function normalizeKeys(keys?: string | string[]): string[] {
  if (isNil(keys)) {
    return [];
  }
  if (typeof keys === "string") {
    return [keys];
  } else {
    return keys;
  }
}

function intoMenuItem(item: RightClickMenuItem): MenuItem[] {
  if ("actionId" in item) {
    return [
      new MenuItem(
        item.title,
        () => {
          let action = ActionRegistry.getInstance().get(item.actionId);
          if (action === undefined) {
            vim.notify(
              `Action ${item.actionId} not found`,
              vim.log.levels.ERROR
            );
            return;
          }
          action.execute();
        },
        {
          keys: normalizeKeys(item.keys),
          alwaysInMenu: item.alwaysInMenu,
          enabled: (buffer: VimBuffer) => {
            let action = ActionRegistry.getInstance().get(item.actionId);
            if (action === undefined) {
              return false;
            }
            return action.enabled(buffer);
          },
        }
      ),
    ];
  } else if ("children" in item) {
    return [
      new MenuItem(item.title, () => {}, {
        children: item.children.map((v) => intoMenuItem(v)).flat(),
        keys: normalizeKeys(item.keys),
      }),
    ];
  } else {
    return [
      new MenuItem("---", () => {}),
      ...item.items.map((v) => intoMenuItem(v)).flat(),
      new MenuItem("---", () => {}),
    ];
  }
}

function filterMenuItems(buffer: VimBuffer, items: MenuItem[]): MenuItem[] {
  let ret = clearContiguousSeparators(
    items.filter((v) => {
      if (!v.enabled(buffer)) {
        return false;
      }
      if (v.children.length > 0) {
        v.children = clearContiguousSeparators(
          filterMenuItems(buffer, v.children)
        );
        if (v.children.length === 0) {
          return false;
        }
      }
      return true;
    })
  );
  // clear last separator
  if (ret.length > 0 && ret[ret.length - 1].text.isSeparator()) {
    ret.pop();
  }
  // clear the first separator
  if (ret.length > 0 && ret[0].text.isSeparator()) {
    ret.shift();
  }
  return ret;
}

function clearContiguousSeparators(items: MenuItem[]): MenuItem[] {
  let ret: MenuItem[] = [];
  let lastIsSeparator = false;
  for (let item of items) {
    if (item.text.isSeparator()) {
      if (lastIsSeparator) {
        continue;
      }
      lastIsSeparator = true;
    } else {
      lastIsSeparator = false;
    }
    ret.push(item);
  }
  return ret;
}

const cppToolkitGroup: RightClickMenuGroup = {
  items: [
    {
      title: "CppToolkit",
      children: [
        {
          title: "Insert header",
          actionId: "cpptoolkit.insert-header",
          keys: "i",
        },
        {
          title: "Generate function implementation",
          actionId: "cpptoolkit.gen-def",
          keys: "d",
        },
        {
          title: "Move value",
          actionId: "cpptoolkit.move-value",
          keys: "m",
        },
        {
          title: "Forward value",
          actionId: "cpptoolkit.forward-value",
          keys: "f",
        },
      ],
    },
  ],
};

const rustaceanvimGroup: RightClickMenuGroup = {
  items: [
    {
      title: "Open cargo.toml",
      actionId: "rustaceanvim.open-cargo-toml",
    },
    {
      title: "Open parent module",
      actionId: "rustaceanvim.open-parent-module",
    },
    {
      title: "Rebuild proc macro",
      actionId: "rustaceanvim.rebuild-proc-macro",
    },
    {
      title: "Explain errors",
      actionId: "rustaceanvim.explain-errors",
    },
    {
      title: 'View syntax tree',
      actionId: 'rustaceanvim.view-syntax-tree',
    }
  ],
};

const flutterGroup: RightClickMenuGroup = {
  items: [
    {
      title: "Flutter: Run",
      actionId: "flutter-tools.run-project",
    },
    {
      title: "Flutter: Restart",
      actionId: "flutter-tools.restart-project",
    },
    {
      title: "Flutter: More",
      children: [
        {
          title: "Flutter: Select devices",
          actionId: "flutter-tools.select-devices",
        },
        {
          title: "Flutter: Select emulators",
          actionId: "flutter-tools.select-emulators",
        },
        {
          title: "Flutter: Hot reload",
          actionId: "flutter-tools.hot-reload",
        },
        {
          title: "Flutter: Quit",
          actionId: "flutter-tools.quit-project",
        },
        {
          title: "Flutter: Detach",
          actionId: "flutter-tools.detach-project",
        },
        {
          title: "Flutter: Toggle outline",
          actionId: "flutter-tools.toggle-outline",
        },
        {
          title: "Flutter: Open outline",
          actionId: "flutter-tools.open-outline",
        },
      ],
    },
  ],
};

const formatFileItem: RightClickMenuActionItem = {
  title: "Format file",
  actionId: "conform.format",
  keys: "c",
};

const copilotGroup: RightClickMenuGroup = {
  items: [
    {
      title: "Copilot",
      children: [
        {
          title: "Copilot status",
          actionId: "copilot.status",
          keys: "s",
        },
        {
          title: "Copilot auth",
          actionId: "copilot.auth",
          keys: "a",
        },
        {
          title: "Copilot panel",
          actionId: "copilot.show-panel",
          keys: "p",
        },
      ],
    },
  ],
};

const builtinLspGroup: RightClickMenuGroup = {
  items: [
    {
      title: "Lsp",
      children: [
        {
          title: "Goto declaration",
          actionId: "builtin.lsp.goto-declaration",
          keys: "d",
        },
        {
          title: "Goto definition",
          actionId: "glance.goto-definition",
          keys: "D",
        },
        {
          title: "Goto implementation",
          actionId: "glance.goto-implementation",
          keys: "i",
        },
        {
          title: "Inspect references",
          actionId: "glance.goto-reference",
          keys: "r",
        },
        {
          title: "Rename symbol",
          actionId: "builtin.lsp.rename",
          keys: "R",
        },
      ],
    },
  ],
};

const bookmarkGroup: RightClickMenuGroup = {
  items: [
    {
      title: "Bookmarks",
      keys: "b",
      children: [
        {
          title: "Add bookmark",
          actionId: "bookmarks.add-bookmark",
          keys: "a",
        },
        {
          title: "Toggle bookmarks",
          actionId: "bookmarks.toggle-bookmarks",
          keys: "t",
        },
        {
          title: "Delete bookmark at virt text line",
          actionId: "bookmarks.delete-at-virt-line",
          keys: "d",
        },
        {
          title: "Show bookmark desc",
          actionId: "bookmarks.show-bookmark-desc",
          keys: "s",
        },
      ],
    },
  ],
};

export const rightClickMenu: RightClickMenuItem[] = [
  formatFileItem,
  cppToolkitGroup,
  rustaceanvimGroup,
  flutterGroup,
  builtinLspGroup,
  bookmarkGroup,
  copilotGroup,
];

export function mountRightClickMenu(buffer: VimBuffer, opt?: any): void {
  let items = rightClickMenu.map((v) => intoMenuItem(v)).flat();
  let menu = new ContextMenu(filterMenuItems(buffer, items));
  vim.schedule(() => {
    menu.asNuiMenu(opt ?? {}).mount();
  });
}
