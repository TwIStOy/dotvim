import { Widget, WidgetKind, _WidgetOption } from "@glib/widget";
import { AnyColor, Color, normalizeColor } from "../_utils";
import {
  FlexibleRange,
  FlexibleSize,
  PixelPosition,
  RenderBox,
} from "@glib/base";
import {
  Box,
  Glue,
  InputItem,
  adjustmentRatios,
  breakLines,
} from "./line-break";
import { FontExtents } from "ht.clib.cairo";
import { debug_, info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import { BuildContext } from "@glib/build-context";

interface TextStyle {
  /**
   * @description The color of the text.
   */
  color?: AnyColor;
  /**
   * @description The font family of the text.
   */
  fontFamily?: string;
  /**
   * @description The font weight of the text.
   */
  fontWeight?: string;
  /**
   * @description The font slant of the text.
   */
  fontSlant?: string;
  /**
   * @description The font size of the text.
   */
  fontSize?: number;
}

interface _TextOpts {
  /**
   * @description The text of the text widget.
   */
  text: string | string[];
  /**
   * @description The max width of lines.
   */
  width?: number;
  /**
   * @description The style of the text.
   */
  style?: TextStyle;
}

export function toUtfChars(str: string): string[] {
  let starts = vim.str_utf_pos(str);
  let res = [];
  for (let i = 0; i < starts.length - 1; i++) {
    res.push(str.slice(starts[i] - 1, starts[i + 1] - 1));
  }
  res.push(str.slice(starts[starts.length - 1] - 1));
  return res;
}

let whiteSpaceChars = [
  "\t",
  "\n",
  "\x0b",
  "\x0c",
  "\r",
  " ",
  "\xc2\x85",
  "\xc2\xa0",
  "\xe1\x9a\x80",
  "\xe1\xa0\x8e",
  "\xe2\x80\x80",
  "\xe2\x80\x81",
  "\xe2\x80\x82",
  "\xe2\x80\x83",
  "\xe2\x80\x84",
  "\xe2\x80\x85",
  "\xe2\x80\x86",
  "\xe2\x80\x87",
  "\xe2\x80\x88",
  "\xe2\x80\x89",
  "\xe2\x80\x8a",
  "\xe2\x80\x8b",
  "\xe2\x80\x8c",
  "\xe2\x80\x8d",
  "\xe2\x80\xa8",
  "\xe2\x80\xa9",
  "\xe2\x80\xaf",
  "\xe2\x81\x9f",
  "\xe2\x81\xa0",
  "\xe3\x80\x80",
  "\xef\xbb\xbf",
];

function isWhiteSpace(char: string): boolean {
  return whiteSpaceChars.includes(char);
}

class _Text extends Widget {
  override readonly kind: WidgetKind = "Text";

  private _text: string[];
  private _width: FlexibleSize;
  private _style: {
    color: Color;
    fontFamily: string;
    fontWeight: string;
    fontSlant: string;
    fontSize: number;
  };

  constructor(opts: _TextOpts) {
    super({
      flexible: "height",
      flexPolicy: "shrink",
    });

    if (type(opts.text) === "string") {
      this._text = [opts.text as string];
    } else {
      this._text = opts.text as string[];
    }
    if (opts.style) {
      this._style = {
        color: normalizeColor(opts.style.color) ?? Color.from("black"),
        fontFamily: ifNil(opts.style.fontFamily, "Sans"),
        fontSlant: ifNil(opts.style.fontSlant, "normal"),
        fontWeight: ifNil(opts.style.fontWeight, "normal"),
        fontSize: ifNil(opts.style.fontSize, 12),
      };
    } else {
      this._style = {
        color: Color.from("black"),
        fontFamily: "Sans",
        fontSlant: "normal",
        fontWeight: "normal",
        fontSize: 12,
      };
    }
    this._width = opts.width ?? "inf";
  }

  _widthRange(
    _context: BuildContext,
    maxAvailable: number,
    _determinedHeight?: number | undefined
  ): FlexibleRange {
    if (this._width === "inf") {
      return {
        min: 0,
        max: maxAvailable,
      };
    } else {
      return {
        min: this._width,
        max: this._width,
      };
    }
  }

  _heightRange(
    context: BuildContext,
    _maxAvailable: number,
    determinedWidth?: number | undefined
  ): FlexibleRange {
    if (isNil(determinedWidth)) {
      let fe = context.renderer.ctx.font_extents();
      return {
        min: fe.height * this._text.length,
        max: "inf",
      };
    } else {
      this._setupFont(context);
      let fe = context.renderer.ctx.font_extents();
      let lines = this._text.reduce((previous, line): number => {
        let cnt = this._breakLine(context, line, determinedWidth);
        return previous + cnt;
      }, 0);
      info(
        "determinedWidth: %s, lines: %s, base: %s",
        determinedWidth,
        lines,
        fe.height
      );
      return {
        min: fe.height * lines,
        max: "inf",
      };
    }
  }

  calculateRenderBox(
    context: BuildContext,
    inheritBox?: RenderBox | undefined
  ): void {
    if (!inheritBox) {
      inheritBox = context.getInitialRenderBox();
    }
    // process margin
    let initBox = this.processMargin(inheritBox);
    this._renderBox = initBox;
  }

  private _setupFont(context: BuildContext) {
    context.renderer.ctx.font_face(
      this._style.fontFamily,
      this._style.fontSlant,
      this._style.fontWeight
    );
    context.renderer.ctx.font_size(this._style.fontSize);
  }

  private _breakLine(context: BuildContext, line: string, width: number) {
    let inputItems = this._lineToInputItems(context, line);
    let breakpoints;
    try {
      breakpoints = breakLines(inputItems, width);
    } catch (e) {
      error(string.format("Cannot break lines: %s", e));
    }
    if (breakpoints[breakpoints.length - 1] + 1 >= inputItems.length) {
      return breakpoints.length + 1;
    } else {
      return breakpoints.length;
    }
  }

  private _lineToInputItems(context: BuildContext, line: string) {
    let chars = toUtfChars(line);
    let inputItems: InputItem[] = [];
    for (let char of chars) {
      let te = context.renderer.ctx.text_extents(char);
      if (isWhiteSpace(char)) {
        inputItems.push({
          type: "glue",
          width: te.x_advance,
          stretch: te.x_advance * 1.5,
          shrink: te.x_advance - 2,
        });
      } else {
        inputItems.push({
          type: "box",
          width: te.x_advance,
          char: char,
        });
      }
    }
    return inputItems;
  }

  private _showLine(
    context: BuildContext,
    line: string,
    initPosition: PixelPosition,
    fe: FontExtents,
    expectWidth: number
  ): number {
    let inputItems = this._lineToInputItems(context, line);
    let breakpoints;
    try {
      breakpoints = breakLines(inputItems, expectWidth);
    } catch (e) {
      error(string.format("Cannot break lines: %s", e));
    }
    let ratios = adjustmentRatios(inputItems, expectWidth, breakpoints);
    let x = initPosition.x;
    let y = initPosition.y;
    debug_(
      "breakpoints: %s, ratios: %s",
      vim.inspect(breakpoints),
      vim.inspect(ratios)
    );

    for (let b = 0; b < breakpoints.length - 1; b++) {
      const start = b === 0 ? breakpoints[0] : breakpoints[b] + 1;
      for (let p = start; p <= breakpoints[b + 1]; p++) {
        if (inputItems[p].type === "box") {
          let item = inputItems[p] as Box;
          let te = context.renderer.ctx.text_extents(item.char);
          context.renderer.ctx.rgba(
            this._style.color.red,
            this._style.color.green,
            this._style.color.blue,
            this._style.color.alpha
          );
          context.renderer.ctx.move_to(x, y - fe.descent);
          context.renderer.ctx.show_text(item.char);
          x += te.x_advance;
        } else if (
          inputItems[p].type === "glue" &&
          p !== start &&
          p !== breakpoints[b + 1]
        ) {
          let item = inputItems[p] as Glue;
          let gap;
          if (ratios[b] < 0) {
            gap = item.width + ratios[b] * item.shrink;
          } else {
            gap = item.width + ratios[b] * item.stretch;
          }
          x += gap;
        }
      }
      x = initPosition.x;
      y += fe.height;
    }
    // write the last line
    const start = breakpoints[breakpoints.length - 1] + 1;
    for (let p = start; p < inputItems.length; p++) {
      if (inputItems[p].type === "box") {
        let item = inputItems[p] as Box;
        let te = context.renderer.ctx.text_extents(item.char);
        context.renderer.ctx.rgba(
          this._style.color.red,
          this._style.color.green,
          this._style.color.blue,
          this._style.color.alpha
        );
        context.renderer.ctx.move_to(x, y - fe.descent);
        context.renderer.ctx.show_text(item.char);
        x += te.x_advance;
      } else if (inputItems[p].type === "glue" && p !== start) {
        let te = context.renderer.ctx.text_extents(" ");
        x += te.x_advance;
      }
    }
    if (start < inputItems.length) {
      x = initPosition.x;
      y += fe.height;
    }
    return y;
  }

  build(context: BuildContext): void {
    this._setupFont(context);

    let fe = context.renderer.ctx.font_extents();
    let position: PixelPosition = {
      x: this._renderBox!.position.x,
      y: this._renderBox!.position.y + fe.height,
    };

    let expectWidth = this._renderBox!.width;

    for (let line of this._text) {
      position.y = this._showLine(context, line, position, fe, expectWidth);
    }
  }
}

export function Text(opts: _TextOpts): Widget {
  return new _Text(opts);
}
