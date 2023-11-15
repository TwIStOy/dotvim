export function NuiInput(
  popupOpts: NuiPopupOptions,
  inputOpts: NuiInputOptions
): NuiInput {
  return luaRequire("nui.input")(popupOpts, inputOpts);
}

export function NuiText(
  content: string | NuiText,
  extmark?: string | TextExtmarkOptions
): NuiText {
  return luaRequire("nui.text")(content, extmark);
}

export function NuiLine(texts?: NuiText[]): NuiLine {
  return luaRequire("nui.line")(texts);
}

export function NuiPopup(opts: NuiPopupOptions): NuiPopup {
  return luaRequire("nui.popup")(opts);
}

export class NuiMenuMod {
  public static item<T>(
    content: string | NuiText | NuiLine,
    data: T
  ): NuiTreeNode<T> {
    return luaRequire("nui.menu").item(content, data);
  }

  public static separator<T>(
    content?: string | NuiText | NuiLine,
    options?: {
      char?: string | NuiText;
      text_align?: "left" | "right" | "center";
    }
  ): NuiTreeNode<T> {
    return luaRequire("nui.menu").separator(content, options);
  }

  public static newMenu<T>(
    popupOpts: NuiPopupOptions,
    menuOpts: NuiMenuOptions<T>
  ): NuiMenu<T> {
    return luaRequire("nui.menu")(popupOpts, menuOpts);
  }
}
