import { info } from "@core/utils/logger";
import { isNil } from "@core/vim";

export function HlGroupToSpanProperties(group: string) {
  let parts = group.split(".");

  let properties = new LuaTable();

  while (parts.length > 0) {
    let name = `${parts.join(".")}`;
    let hl = vim.api.nvim_get_hl(0, {
      name,
      link: true,
    });
    while (hl.has("link")) {
      let linkName = hl.get("link")!;
      hl = vim.api.nvim_get_hl(0, {
        name: linkName,
        link: true,
      });
    }
    if (!properties.has("foreground") && hl.has("guifg")) {
      let fg = hl.get("guifg")!;
      if (!isNil(fg) && fg !== "") {
        properties.set("foreground", string.format("#%06x", fg));
      }
    }
    if (!properties.has("foreground") && hl.has("fg")) {
      let fg = hl.get("fg")!;
      if (!isNil(fg) && fg !== "") {
        properties.set("foreground", string.format("#%06x", fg));
      }
    }
    if (!properties.has("background") && hl.has("bg")) {
      let bg = hl.get("bg")!;
      if (!isNil(bg) && bg !== "") {
        properties.set("background", string.format("#%06x", bg));
      }
    }
    if (!properties.has("background") && hl.has("guibg")) {
      let bg = hl.get("guibg")!;
      if (!isNil(bg) && bg !== "") {
        properties.set("background", string.format("#%06x", bg));
      }
    }
    if (!properties.has("underline") && hl.has("underline")) {
      let underline = hl.get("underline")!;
      if (!isNil(underline) && underline === true) {
        properties.set("underline", "single");
      }
    }
    if (!properties.has("underline") && hl.has("undercurl")) {
      let undercurl = hl.get("undercurl")!;
      if (!isNil(undercurl) && undercurl === true) {
        properties.set("underline", "error");
      }
    }
    if (!properties.has("underline_color") && hl.has("sp")) {
      let sp = hl.get("sp")!;
      if (!isNil(sp) && sp !== "") {
        properties.set("underline_color", string.format("#%06x", sp));
      }
    }

    parts.pop();
  }

  info("Hl, %s, %s", group, properties);

  return properties;
}
