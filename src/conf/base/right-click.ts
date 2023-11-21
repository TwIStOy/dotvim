export const RightClickIndexes = {
  textobjects: 1,
  treesj: 11,

  // languages
  crates: 41,
  http: 41,

  // tools
  conform: 50,
};

export type RightClickGroups = {
  treesitter: 1;
  default: 1000;
};

interface RightClickMenuItemBase {
  title: string;
  keys?: string | string[];
}

interface RightClickMenuActionItem extends RightClickMenuItemBase {
  actionId: string;
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

export const RightClickMenu: RightClickMenuItem[] = [CppToolkitGroup];
