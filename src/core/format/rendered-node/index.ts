import { info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import * as lgi from "lgi";
import { highlightContent } from "./codeblock";

function escapeMarkup(str: string): string {
  return lgi.GLib.markup_escape_text(str, -1);
}

export type RenderedNodeKind =
  | "paragraph"
  | "span"
  | "i"
  | "b"
  | "heading"
  | "code_block"
  | "section"
  | "code_span";

type StringOrNode = string | RenderedNode;
export type RenderedNodeContent = StringOrNode | StringOrNode[];

export class PangoMarkupGenerator {
  result: string[] = [];
  currentMarkup: string[] = [];

  newParagraph() {
    this.result.push(this.currentMarkup.join(""));
    this.currentMarkup = [];
  }

  addLines(lines: string | string[], pid?: number) {
    if (typeof lines === "string") {
      if (pid === undefined || pid >= this.result.length) {
        this.currentMarkup.push(lines);
      } else {
        this.result[pid] += lines;
      }
    } else {
      if (pid === undefined || pid >= this.result.length) {
        this.currentMarkup.push(...lines);
      } else {
        this.result[pid] += lines.join("");
      }
    }
    return this.result.length;
  }

  done(): string[] {
    if (this.currentMarkup.length > 0) {
      this.result.push(this.currentMarkup.join(""));
      this.currentMarkup = [];
    }
    let result = this.result;
    // clean empty tags
    result = result
      .map((line) => line.replaceAll("<span></span>", "").trim())
      .filter((line) => line.length > 0)
      .map((line) => this._addCommonTag(line));
    return result;
  }

  private _addCommonTag(p: string) {
    let normal = vim.api.nvim_get_hl(0, {
      name: "Normal",
    });
    info("normal, %s", normal);
    let foreground = ifNil(normal.get("guifg"), normal.get("fg"));
    let background = ifNil(normal.get("guibg"), normal.get("bg"));
    let openTag = "<span";
    if (!isNil(foreground)) {
      openTag += ` foreground="#${string.format("%06x", foreground)}"`;
    }
    if (!isNil(background)) {
      openTag += ` background="#${string.format("%06x", background)}"`;
    }
    openTag += ">";
    return `${openTag}${p}</span>`;
  }
}

export abstract class RenderedNode {
  kind: RenderedNodeKind;
  content: RenderedNodeContent;
  params?: any;

  protected constructor(
    kind: RenderedNodeKind,
    content: RenderedNodeContent,
    params?: any
  ) {
    this.kind = kind;
    this.content = content;
    this.params = params;
  }

  abstract startNewParagraph(): boolean;

  abstract intoPangoMarkup(pango: PangoMarkupGenerator): void;
}

abstract class SimpleWrapperNode extends RenderedNode {
  protected constructor(
    kind: RenderedNodeKind,
    content: RenderedNodeContent,
    params?: any
  ) {
    super(kind, content, params);
  }

  abstract openTag(): string;

  abstract closeTag(): string;

  override intoPangoMarkup(pango: PangoMarkupGenerator): void {
    info("kind: %s, new: %s", this.kind, this.startNewParagraph());

    if (this.startNewParagraph()) {
      pango.newParagraph();
    }

    let start = pango.addLines(this.openTag());
    if (typeof this.content === "string") {
      pango.addLines(escapeMarkup(this.content));
    } else if (vim.tbl_islist(this.content)) {
      for (let item of this.content) {
        if (typeof item === "string") {
          pango.addLines(escapeMarkup(item));
        } else {
          item.intoPangoMarkup(pango);
        }
      }
    } else {
      this.content.intoPangoMarkup(pango);
    }
    pango.addLines(this.closeTag(), start);
  }
}

export class ItalicNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent) {
    super("i", content);
  }

  openTag(): string {
    return "<i>";
  }

  closeTag(): string {
    return "</i>";
  }

  startNewParagraph(): boolean {
    return false;
  }
}

export class BoldNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent) {
    super("b", content);
  }

  openTag(): string {
    return "<b>";
  }
  closeTag(): string {
    return "</b>";
  }

  startNewParagraph(): boolean {
    return false;
  }
}

export class CodeBlockNode extends SimpleWrapperNode {
  constructor(content: string, lang: string | null) {
    super("code_block", content, lang);
  }

  openTag(): string {
    return '<span allow_breaks="false"><tt>';
  }

  closeTag(): string {
    return "</tt></span>";
  }

  startNewParagraph(): boolean {
    return true;
  }

  intoPangoMarkup(pango: PangoMarkupGenerator): void {
    let content = this.content as string;
    let language = this.params as string | null;
    if (language !== null) {
      highlightContent(pango, content, language);
    } else {
      super.intoPangoMarkup(pango);
    }
  }
}

export class SpanNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent, params?: any) {
    super("span", content, params);
  }

  openTag(): string {
    let result = "<span";
    if (!isNil(this.params)) {
      let properties = this.params as LuaTable<string, any>;
      for (let [key, value] of properties) {
        result += ` ${key}="${value}"`;
      }
    }
    result += ">";

    return result;
  }

  closeTag(): string {
    return "</span>";
  }

  startNewParagraph(): boolean {
    return false;
  }
}

export class HeadingNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent, level: number) {
    super("heading", content, level);
  }

  openTag(): string {
    let level = this.params! as number;
    if (level === 1) {
      return `<span font_size="200%">`;
    } else if (level === 2) {
      return `<span font_size="150%">`;
    } else if (level === 3) {
      return `<span font_size="120%">`;
    }
    return `<span>`;
  }

  closeTag(): string {
    return "</span>";
  }

  startNewParagraph(): boolean {
    return true;
  }
}

export class SectionNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent) {
    super("section", content);
  }

  openTag(): string {
    return "<span>";
  }

  closeTag(): string {
    return "</span>";
  }

  startNewParagraph(): boolean {
    return true;
  }
}

export class ParagraphNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent) {
    super("paragraph", content);
  }

  openTag(): string {
    return "";
  }

  closeTag(): string {
    return "";
  }

  startNewParagraph(): boolean {
    return true;
  }
}

export class CodeSpanNode extends SimpleWrapperNode {
  constructor(content: string) {
    super("code_span", content);
  }

  openTag(): string {
    return '<span allow_breaks="false"><tt>';
  }

  closeTag(): string {
    return "</tt></span>";
  }

  startNewParagraph(): boolean {
    return false;
  }
}
