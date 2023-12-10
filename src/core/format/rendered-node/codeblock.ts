import { info } from "@core/utils/logger";
import { PangoMarkupGenerator } from ".";
import { isNil } from "@core/vim";

type MarkerKind = "start" | "end";

interface HighlightMarkerStart {
  kind: "start";
  capture: string;
  offset: number;
}

interface HighlightMarkerEnd {
  kind: "end";
  offset: number;
}

type HighlightMarker = HighlightMarkerStart | HighlightMarkerEnd;

export function highlightContent(
  pango: PangoMarkupGenerator,
  content: string,
  language: string
) {
  let parser = vim.treesitter.get_string_parser(content, language);
  let highlights = vim.treesitter.query.get(language, "highlights");
  let root = parser.parse(true)[0].root();
  let markers: HighlightMarker[] = [];
  for (let [id, node, _metadata] of highlights.iter_captures(root, content)) {
    let capture = highlights.captures.get(id);
    let [_startLine, _startCol, startByte, _endLine, _endCol, endByte] =
      node.range(true);
    let text = content.slice(startByte, endByte);
    info("capture: %s, type: %s, text: %s", capture, node.type(), text);
    markers.push({
      kind: "start",
      capture,
      offset: startByte,
    });
    markers.push({
      kind: "end",
      offset: endByte,
    });
  }
  markers = markers.sort((a, b) => a.offset - b.offset);
  let m = 0;
  pango.addLines('<span allow_breaks="false"><tt>');
  for (let i = 0; i < content.length; i++) {
    while (m < markers.length && markers[m].offset <= i) {
      let marker = markers[m];
      if (marker.kind === "start") {
        pango.addLines(intoOpenTag(marker.capture));
      } else {
        pango.addLines("</span>");
      }
      m++;
    }
    pango.addLines(content[i]);
  }
  pango.addLines("</tt></span>");
}

function intoOpenTag(capture: string): string {
  let parts = capture.split(".");

  let properties = new LuaTable();

  while (parts.length > 0) {
    let name = `@${parts.join(".")}`;
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

  let result = "<span";
  for (let [key, value] of properties) {
    result += ` ${key}="${value}"`;
  }
  result += ">";
  return result;
}
