function _(module: string) {
  return luaRequire(module) as any as (...args: any[]) => any;
}

export function NuiText(
  content: string | NuiText,
  extmark?: string | TextExtmarkOptions
): NuiText {
  return _("nui.text")(content, extmark);
}

export function NuiLine(texts: NuiText[]): NuiLine {
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
