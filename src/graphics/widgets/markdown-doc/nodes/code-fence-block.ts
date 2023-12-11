import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { isNil } from "@core/vim";
import { escapeMarkup } from "@core/format/rendered-node/util";
import { info } from "@core/utils/logger";
import { HlGroupToSpanProperties } from "@core/format/rendered-node/hl";
import { MdNode } from "../base";
import { PangoSpanProperties } from "../property";
import { Markup } from "@glib/widgets/markup";
import { Column } from "@glib/widgets/column";

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

export class MdCodeFenceBlock extends MdNode {
  private code: string;
  private language: string | null;

  constructor(node: TSNode, source: string, inherit: PangoSpanProperties[]) {
    super(node, source, inherit);

    [this.code, this.language] = this.getContent();
  }

  override isEmpty(): boolean {
    return false;
  }

  getContent() {
    let [_startRow, _startColumn, startByte] = this.node.start();
    let [_endRow, _endColumn, endByte] = this.node.end_();

    let language = null;

    // first is fenced_code_block_delimiter
    {
      let firstChild = this.node.child(0);
      let [_childStartRow, _childStartColumn, childStartByte] =
        firstChild.start();
      assert(childStartByte === startByte);
      startByte += firstChild.byte_length();
    }

    // find info_string child
    for (let i = 0; i < this.node.child_count(); i++) {
      let child = this.node.child(i);
      if (child.type() === "info_string") {
        language = vim.treesitter.get_node_text(child, this.source);
        let [_childEndRow, _childEndColumn, childEndByte] = child.end_();
        startByte = childEndByte;
        break;
      }
    }

    // last is fenced_code_block_delimiter
    {
      let lastChild = this.node.child(this.node.child_count() - 1);
      let [_childStartRow, _childStartColumn, childStartByte] =
        lastChild.start();
      endByte = childStartByte;
    }

    let [code] = this.source.slice(startByte, endByte).trim();
    return [code, language] as const;
  }

  intoWidgetOrSpan(_context: BuildContext): Widget {
    let packedProperties = this.packProperties();
    let widgets: Widget[] = [];
    if (isNil(this.language)) {
      // simple lines
      let lines = this.code.split("\n");
      for (let line of lines) {
        widgets.push(
          Markup(
            `<span ${packedProperties}><tt>${escapeMarkup(line)}</tt></span>`
          )
        );
      }
    } else {
      let lines = this.highlightLines(this.code, this.language);
      for (let line of lines) {
        widgets.push(
          Markup(`<span ${packedProperties}><tt>${line}</tt></span>`)
        );
      }
    }
    return Column({
      children: widgets,
    });
  }

  highlightLines(content: string, language: string) {
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
    info("markers: %s", markers);

    let stack = [];
    let lines = [];
    let currentLine = [];
    let m = 0;
    for (let i = 0; i < content.length; i++) {
      while (m < markers.length && markers[m].offset <= i) {
        let marker = markers[m];
        if (marker.kind === "start") {
          stack.push(intoOpenTag(marker.capture));
          currentLine.push(stack[stack.length - 1]);
        } else {
          stack.pop();
          currentLine.push("</span>");
        }
        m++;
      }
      currentLine.push(escapeMarkup(content[i]));
      if (content[i] === "\n") {
        for (let j = 0; j < stack.length; j++) {
          currentLine.push("</span>");
        }
        lines.push(currentLine.join(""));
        currentLine = [];
        for (let j = 0; j < stack.length; j++) {
          currentLine.push(stack[j]);
        }
      }
    }
    if (currentLine.length > 0) {
      for (let j = 0; j < stack.length; j++) {
        currentLine.push("</span>");
      }
      lines.push(currentLine.join(""));
    }
    return lines;
  }
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
