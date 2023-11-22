import { ActionRegistry, AvailableActions } from "@conf/plugins";
import { ContextMenu } from "@core/components/context-menu";
import { MenuItem } from "@core/components/menu-item";
import { MenuText } from "@core/components/menu-text";
import { Cache } from "@core/model";
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

function intoMenuItem(buffer: VimBuffer, item: RightClickMenuItem): MenuItem[] {
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
          enabled: () => {
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
        children: item.children.map((v) => intoMenuItem(buffer, v)).flat(),
        keys: normalizeKeys(item.keys),
      }),
    ];
  } else {
    return [
      new MenuItem("---", () => {}),
      ...item.items.map((v) => intoMenuItem(buffer, v)).flat(),
    ];
  }
}

const CppToolkitGroup: RightClickMenuGroup = {
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

const RustToolkitGroup: RightClickMenuGroup = {
  items: [
    {
      title: "Open cargo.toml",
      actionId: "rust-tools.open-cargo-toml",
    },
    {
      title: "Open parent module",
      actionId: "rust-tools.open-parent-module",
    },
  ],
};

const FormatFileItem: RightClickMenuActionItem = {
  title: "Format file",
  actionId: "conform.format",
  keys: "c",
};

const CopilotGroup: RightClickMenuGroup = {
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

export const rightClickMenu: RightClickMenuItem[] = [
  FormatFileItem,
  CppToolkitGroup,
  RustToolkitGroup,
  CopilotGroup,
];

const _rightClickMenuCache = new Cache();

export function mountRightClickMenu(buffer: VimBuffer, opt?: any): void {
  let items = _rightClickMenuCache.ensure(buffer.asCacheKey(), () => {
    return rightClickMenu.map((v) => intoMenuItem(buffer, v)).flat();
  });
  let menu = new ContextMenu(items);
  vim.schedule(() => {
    menu.asNuiMenu(opt ?? {}).mount();
  });
}