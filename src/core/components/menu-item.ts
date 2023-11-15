import { uniqueArray } from "@core/utils/array";
import { MenuText } from "./menu-text";
import { NuiMenuMod } from "@extra/nui";
import { ContextMenu } from "./context-menu";

const builtinKeys = [
  "j",
  "k",
  "h",
  "l",
  "q",
  "<ESC>",
  "<C-c>",
  "<CR>",
  "<TAB>",
  "<S-TAB>",
  "<C-n>",
  "<C-p>",
  "<UP>",
  "<DOWN>",
];

function removeBuiltinKeys(keys: string[]) {
  return keys.filter((key) => !builtinKeys.includes(key));
}

/**
 * A menu item component.
 */
export class MenuItem {
  public text: MenuText;
  public children: MenuItem[];
  public description?: string;
  public callback: (this: void) => void;

  private _keys: string[];

  constructor(
    text: string | MenuText,
    callback: () => void,
    options?: {
      children?: MenuItem[];
      description?: string;
      keys?: string[];
    }
  ) {
    this.text = typeof text === "string" ? new MenuText(text) : text;
    this.children = options?.children ?? [];
    this.description = options?.description;
    this.callback = callback;

    this._keys = removeBuiltinKeys(
      uniqueArray([...this.text.keys, ...(options?.keys ?? [])])
    );
  }

  /**
   * Get the menu item's keys.
   *
   * @returns The menu item's keys.
   */
  public get keys(): string[] {
    return this._keys;
  }

  public get length(): number {
    if (this.text.isSeparator()) {
      return 0;
    }
    let ret = this.text.length;

    if (this.keys.length > 0) {
      ret += 3 + this.keys.length;
      for (const key of this.keys) {
        ret += key.length;
      }
    }

    if (this.children.length > 0) {
      ret += 2;
    }

    return ret;
  }

  asNuiTreeNode(textWidth: number): NuiTreeNode<MenuItemContext> {
    if (this.text.isSeparator()) {
      return NuiMenuMod.separator(undefined, {
        char: "-",
      });
    }

    let text = this.text.asNuiLine();
    let length = this.length;

    if (this.keys.length > 0) {
      let hint = this.keys.join("|");
      let spaceCount = textWidth - 2 - length - hint.length;
      if (spaceCount > 0) {
        text.append(" ".repeat(spaceCount));
      }
      text.append(hint, "@variable.builtin");
      length += spaceCount + hint.length;
    }

    if (this.children.length > 0) {
      let spaceCount = textWidth - 2 - length;
      if (spaceCount > 0) {
        text.append(" ".repeat(spaceCount));
      }
      text.append("▸", "@variable.builtin");
    }

    return NuiMenuMod.item(text, {
      menuItem: this,
      parent: null,
    });
  }
}

export type MenuItemContext = {
  menuItem: MenuItem;
  parent: ContextMenu | null;
};
