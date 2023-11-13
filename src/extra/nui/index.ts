function _(module: string) {
  return luaRequire(module) as any as (...args: any[]) => any;
}

export function NuiText(
  content: string | NuiText,
  extmark?: string | TextExtmarkOptions
): NuiText {
  return _("nui.text")(content, extmark);
}

export function NuiLine(texts?: NuiText[]): NuiLine {
  return _("nui.line")(texts);
}

export function NuiPopup(opts: NuiPopupOptions): NuiPopup {
  return _("nui.popup")(opts);
}

export function NuiInput(
  popupOpts: NuiPopupOptions,
  inputOpts: NuiInputOptions
): NuiInput {
  return _("nui.input")(popupOpts, inputOpts);
}

class _NuiMenu {
  static item(content: string | NuiText | NuiLine, data: any): NuiMenuItem {
    return luaRequire("nui.menu").item(content, data);
  }

  static separator(
    content?: string | NuiText | NuiLine,
    options?: {
      char?: string | NuiText;
      text_align?: "left" | "right" | "center";
    }
  ): NuiMenuItem {
    return luaRequire("nui.menu").separator(content, options);
  }

  public call(popupOpts: NuiPopupOptions, menuOpts: NuiMenuOptions): NuiMenu {
    return luaRequire("nui.menu")(popupOpts, menuOpts);
  }
}

export const NuiMenu = new _NuiMenu();

class _NuiTree {
  static node(
    data: {
      id: string;
      text: string;
    },
    children?: NuiTreeNode[]
  ): NuiTreeNode {
    return luaRequire("nui.tree").node(data, children);
  }
}

export const NuiTree = new _NuiTree();
