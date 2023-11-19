import { uniqueArray } from "@core/utils/array";
import { MenuText } from "./menu-text";
import { NuiMenuMod } from "@extra/nui";
import { ContextMenu, ContextMenuContext } from "./context-menu";

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
  public parent?: NuiMenu<MenuItemContext, ContextMenuContext>;

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

  public get textLength(): number {
    if (this.text.isSeparator()) {
      return 0;
    }
    return this.text.length;
  }

  public getPartLength() {
    if (this.text.isSeparator()) {
      return {
        textLength: 0,
        keysLength: 0,
        childrenLength: 0,
      };
    }

    const textLength = this.text.length + 3;

    let keysLength = 0;
    if (this.keys.length > 0) {
      keysLength = this.keys.length;
      for (const key of this.keys) {
        keysLength += key.length;
      }
    }

    let childrenLength = 0;
    if (this.children.length > 0) {
      childrenLength = 2; // ▸ mark
    }
    return {
      textLength,
      keysLength,
      childrenLength,
    };
  }

  asNuiTreeNode(opts: {
    textLength: number;
    keysLength: number;
    childrenLength: number;
  }): NuiTreeNode<MenuItemContext> {
    if (this.text.isSeparator()) {
      return NuiMenuMod.separator(undefined, {
        char: "-",
      });
    }

    let line = this.text.asNuiLine();

    fillSpaces(line, this.text.length, opts.textLength);

    if (this.keys.length > 0) {
      let hint = this.keys.join("|");
      line.append(hint, "@variable.builtin");
      fillSpaces(line, hint.length, opts.keysLength);
    }

    if (this.children.length > 0) {
      line.append("▸ ", "@variable.builtin");
    } else {
      fillSpaces(line, 0, opts.childrenLength);
    }

    return NuiMenuMod.item(line, {
      menuItem: this,
      parent: null,
    });
  }
}

function fillSpaces(line: NuiLine, length: number, expect: number) {
  if (expect > length) {
    line.append(" ".repeat(expect - length));
  }
}

export type MenuItemContext = {
  menuItem: MenuItem;
  parent: ContextMenu | null;
};
