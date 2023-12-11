import { info } from "@core/utils/logger";
import { PangoMarkupGenerator } from ".";
import { isNil } from "@core/vim";
import { escapeMarkup } from "./util";
import { HlGroupToSpanProperties } from "./hl";

type MarkerKind = "start" | "end";

interface HighlightMarkerStart {
  kind: "start";
  capture: string;
  offset: number;
}

interface HighlightMarkerEnd {
  kind: "end";
  offset: number;
  startOffset: number;
}

type HighlightMarker = HighlightMarkerStart | HighlightMarkerEnd;

export function highlightContent(
  pango: PangoMarkupGenerator,
  content: string,
  language: string
) {
  // load `nvim-treesitter` if not loaded
  {
    let _ = luaRequire("nvim-treesitter.configs");
  }
  let parser = vim.treesitter.get_string_parser(content, language);
  if (isNil(parser)) {
    error(string.format("failed to get parser for language: %s", language));
  }
  let highlights = vim.treesitter.query.get(language, "highlights");
  let root = parser.parse(true)[0].root();
  let markers: HighlightMarker[] = [];
  for (let [id, node, _metadata] of highlights.iter_captures(root, content)) {
    let capture = highlights.captures.get(id);
    let [_startLine, _startCol, startByte, _endLine, _endCol, endByte] =
      node.range(true);
    let text = content.slice(startByte, endByte);
    info("capture: %s, type: %s, text: %s", capture, node.type(), text);
    if (startByte < endByte) {
      markers.push({
        kind: "start",
        capture,
        offset: startByte,
      });
      markers.push({
        kind: "end",
        offset: endByte,
        startOffset: startByte,
      });
    }
  }
  assert(markers.length % 2 === 0);
  markers = markers.sort((a, b) => {
    if (a.offset !== b.offset) {
      return a.offset - b.offset;
    }
    if (a.kind === b.kind) {
      return 0;
    }
    if (a.kind === "end") {
      return -1;
    }
    return 1;
  });
  let m = 0;
  info("markers: %s", markers);
  pango.addLines('<span><tt>');
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
    pango.addLines(escapeMarkup(content[i]));
  }
  while (m < markers.length) {
    let marker = markers[m];
    if (marker.kind === "start") {
      pango.addLines(intoOpenTag(marker.capture));
    } else {
      pango.addLines("</span>");
    }
    m++;
  }
  pango.addLines("</tt></span>");
}

function intoOpenTag(capture: string): string {
  let properties = HlGroupToSpanProperties(`@${capture}`);

  let result = "<span";
  for (let [key, value] of properties) {
    result += ` ${key}="${value}"`;
  }
  result += ">";
  return result;
}
