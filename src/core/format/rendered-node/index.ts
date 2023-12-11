import { info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import { highlightContent } from "./codeblock";
import { escapeMarkup } from "./util";
import { SpanProperties } from "../markup/property";

export type RenderedNodeKind =
  | "paragraph"
  | "span"
  | "i"
  | "b"
  | "heading"
  | "code_block"
  | "section"
  | "code_span"
  | "thematic_break"
  | "list"
  | "list_item";

type StringOrNode = string | RenderedNode;
export type RenderedNodeContent = StringOrNode | StringOrNode[];

export type RenderedElementKind = "line" | "sep" | "lines";

interface MarkupLineElement {
  kind: "line";
  markup: string;
}

interface SeparatorElement {
  kind: "sep";
  width: number;
}

interface ParagraphElement {
  kind: "lines";
  lines: RenderedElement[];
}

export type RenderedElement =
  | MarkupLineElement
  | SeparatorElement
  | ParagraphElement;

interface Tag {
  open: string;
  close: string;
}

export class PangoMarkupGenerator {
  result: RenderedElement[] = [];

  openTags: Tag[] = [];
  currentParagraph: RenderedElement[] = [];
  currentLine: string[] = [];
  currentLineDirty: boolean = false;

  newLine() {
    info("@@@@ newline: %s, parts: [%s]", this.currentLineDirty, this.currentLine)
    if (this.currentLineDirty) {
      // close all tags
      for (let i = this.openTags.length - 1; i >= 0; i--) {
        this.currentLine.push(this.openTags[i].close);
      }
      this.currentParagraph.push({
        kind: "line",
        markup: this.currentLine.join(""),
      });
      this.currentLine = [];
      for (let i = 0; i < this.openTags.length; i++) {
        this.currentLine.push(this.openTags[i].open);
      }
      this.currentLineDirty = false;
    }
  }

  newParagraph() {
    this.newLine();

    if (this.currentParagraph.length > 0) {
      this.result.push({
        kind: "lines",
        lines: this.currentParagraph,
      });
      this.currentParagraph = [];
    }
  }

  addSpe() {
    this.newParagraph();
    this.currentParagraph.push({
      kind: "sep",
      width: 2,
    });
    this.newParagraph();
  }

  appendLine(s: string) {
    if (s.length > 0) {
      this.currentLine.push(s);
      this.currentLineDirty = true;
    }
  }

  appendStr(s: string) {
    if (s.length > 0) {
      let parts = s.split("\n");
      for (let i = 0; i < parts.length; i++) {
        if (i > 0) {
          this.newLine();
        }
        if (parts[i].length > 0) {
          this.currentLine.push(parts[i]);
          this.currentLineDirty = true;
        }
      }
    }
  }

  private static strip(e: RenderedElement): RenderedElement {
    if (e.kind === "line") {
      e.markup = e.markup.replaceAll("<span></span>", "").trim();
    } else if (e.kind === "lines") {
      e.lines = e.lines.map((p) => {
        return PangoMarkupGenerator.strip(p);
      });
    }
    return e;
  }

  private static notEmpty(e: RenderedElement): boolean {
    if (e.kind === "line") {
      return e.markup.length > 0;
    } else if (e.kind === "lines") {
      return e.lines.some((p) => {
        return PangoMarkupGenerator.notEmpty(p);
      });
    }
    return true;
  }

  done(): RenderedElement[] {
    this.newParagraph();

    let result = this.result;
    // clean empty tags
    result = result
      .map((p) => {
        return PangoMarkupGenerator.strip(p);
      })
      .filter((p) => {
        if (p.kind === "line") {
          return p.markup.length > 0;
        }
        return true;
      })
      .map((p) => {
        return PangoMarkupGenerator.addCommonTag(p);
      });
    return result;
  }

  pushTag(open: string, close: string) {
    this.openTags.push({
      open,
      close,
    });
    this.currentLine.push(open);
  }

  popTag(close: string) {
    let previous = this.openTags.pop();
    assert(previous);
    assert(previous?.close === close);
    this.currentLine.push(close);
  }

  private static _addCommonTag(p: string) {
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
    openTag += ` size="15pt"`;
    openTag += ">";
    return `${openTag}${p}</span>`;
  }

  private static addCommonTag(p: RenderedElement) {
    if (p.kind === "line") {
      p.markup = PangoMarkupGenerator._addCommonTag(p.markup);
    } else if (p.kind === "lines") {
      p.lines = p.lines.map((p) => {
        return PangoMarkupGenerator.addCommonTag(p);
      });
    }
    return p;
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

  abstract intoPangoMarkup(pango: PangoMarkupGenerator): void;

  empty(): boolean {
    if (typeof this.content === "string") {
      return this.content.trimEnd().length === 0;
    } else if (vim.tbl_islist(this.content)) {
      if (this.content.length === 0) {
        return true;
      }
      for (let item of this.content) {
        if (typeof item === "string") {
          if (item.trimEnd().length > 0) {
            return false;
          }
        } else {
          if (!item.empty()) {
            return false;
          }
        }
      }
    }
    return false;
  }
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

  abstract startNewParagraph(): boolean;

  override intoPangoMarkup(pango: PangoMarkupGenerator): void {
    info("kind: %s, new: %s", this.kind, this.startNewParagraph());

    if (this.startNewParagraph()) {
      pango.newParagraph();
    }

    pango.pushTag(this.openTag(), this.closeTag());
    if (typeof this.content === "string") {
      pango.appendStr(escapeMarkup(this.content));
    } else if (vim.tbl_islist(this.content)) {
      for (let item of this.content) {
        if (typeof item === "string") {
          pango.appendStr(escapeMarkup(item));
        } else {
          item.intoPangoMarkup(pango);
        }
      }
    } else {
      this.content.intoPangoMarkup(pango);
    }
    pango.popTag(this.closeTag());
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
      pango.newParagraph();
      highlightContent(pango, content.trim(), language);
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
    return "<span><tt>";
  }

  closeTag(): string {
    return "</tt></span>";
  }

  startNewParagraph(): boolean {
    return false;
  }
}

export class ThematicBreak extends RenderedNode {
  constructor() {
    super("thematic_break", "");
  }

  override intoPangoMarkup(pango: PangoMarkupGenerator): void {
    pango.addSpe();
  }
}

export class ListItemNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent) {
    super("list_item", content);
  }

  openTag(): string {
    return "<span> - ";
  }

  closeTag(): string {
    return "</span>";
  }

  startNewParagraph(): boolean {
    return true;
  }
}

export class ListNode extends SimpleWrapperNode {
  constructor(content: RenderedNodeContent) {
    super("list", content);
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
