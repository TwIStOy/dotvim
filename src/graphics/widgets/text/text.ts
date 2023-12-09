import { Cache } from "@core/model";
import { info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import {
  FlexibleRange,
  FlexibleSize,
  PixelPosition,
  RenderBox,
} from "@glib/base";
import { BuildContext } from "@glib/build-context";
import { Widget, WidgetKind } from "@glib/widget";
import { normalizeColor } from "../_utils";
import { TextOverflowPolicy, TextStyle } from "./common";
import {
  Box,
  Glue,
  InputItem,
  adjustmentRatios,
  breakLines,
} from "./line-break";
import { TextSpan, _TextSpan } from "./text-span";

interface _TextOpts {
  /**
   * @description The text of the text widget.
   */
  text: string | _TextSpan | _TextSpan[];
  /**
   * @description The max width of lines.
   */
  width?: number;
  /**
   * @description The style of the text. If text is string.
   */
  style?: TextStyle;
  /**
   * @description The overflow policy of the text.
   */
  overflow?: TextOverflowPolicy;
}

class _Text extends Widget {
  override readonly kind: WidgetKind = "Text";

  private _text: _TextSpan[];
  private _width: FlexibleSize;
  private _cache: Cache = new Cache();
  private _overflow: TextOverflowPolicy;

  constructor(opts: _TextOpts) {
    super({
      flexible: "height",
      flexPolicy: "shrink",
    });

    if (typeof opts.text === "string") {
      this._text = [
        TextSpan({
          text: opts.text,
          style: opts.style,
        }),
      ];
    } else if (vim.tbl_islist(opts.text)) {
      this._text = opts.text;
    } else {
      this._text = [opts.text];
    }

    this._width = opts.width ?? "inf";
    this._overflow = ifNil(opts.overflow, {
      kind: "wrap",
      algorithm: "tex",
    } as const);
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

  private _getInputItems(context: BuildContext): InputItem[] {
    return this._cache.ensure(["input-items", context.key], () => {
      let res: InputItem[] = [];
      for (let span of this._text) {
        res.push(...span.toInputItems(context));
      }
      return res;
    });
  }

  private _getBreakpoints(context: BuildContext, width: number) {
    return this._cache.ensure(["break-lines", context.key, width], () => {
      let inputItems = this._getInputItems(context);
      return breakLines(inputItems, width);
    });
  }

  private _getAdjustmentRatios(context: BuildContext, width: number) {
    return this._cache.ensure(["adjustment-ratios", context.key, width], () => {
      let inputItems = this._getInputItems(context);
      let breakpoints = this._getBreakpoints(context, width);
      return adjustmentRatios(inputItems, width, breakpoints);
    });
  }

  private _expectLines(context: BuildContext, width: number) {
    let breakpoints = this._getBreakpoints(context, width);
    if (breakpoints[breakpoints.length - 1] + 1 < this._text.length) {
      return breakpoints.length + 1;
    } else {
      return breakpoints.length;
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
      let lines = this._expectLines(context, determinedWidth);
      // TODO(hawtian): calc each lines's height
      let fe = context.renderer.ctx.font_extents();
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

  private setupFont(context: BuildContext, style: TextStyle) {
    context.renderer.ctx.font_face(
      ifNil(style.fontFamily, _TextSpan.defaultStyle.fontFamily),
      ifNil(style.fontSlant, _TextSpan.defaultStyle.fontSlant),
      ifNil(style.fontWeight, _TextSpan.defaultStyle.fontWeight)
    );
    context.renderer.ctx.font_size(
      ifNil(style.fontSize, _TextSpan.defaultStyle.fontSize)
    );
  }

  /*
   * pos: top-left corner of the box
   *
   * @returns box size
   */
  private _drawBox(
    context: BuildContext,
    item: Box,
    pos: PixelPosition
  ): {
    width: number;
    height: number;
  } {
    let char = item.char;
    let style = item.style;
    this.setupFont(context, style);
    let fe = context.renderer.ctx.font_extents();
    let te = context.renderer.ctx.text_extents(char);
    if (style.background) {
      let color = normalizeColor(style.background)!;
      context.renderer.ctx.move_to(pos.x, pos.y);
      context.renderer.fillColor = color;
      context.renderer.rectangle(pos.x, pos.y, te.x_advance + 0.5, fe.height);
      context.renderer.fill();
    }
    context.renderer.ctx.move_to(pos.x, pos.y + fe.height - fe.descent);
    context.renderer.color = style.color!;
    context.renderer.ctx.show_text(char);
    // TODO(hawtian): draw underline
    return {
      width: te.x_advance,
      height: fe.height,
    };
  }

  private _drawGlue(
    context: BuildContext,
    item: Glue,
    pos: PixelPosition,
    ratio: number
  ): {
    width: number;
    height: number;
  } {
    let style = item.style;
    this.setupFont(context, style);
    let fe = context.renderer.ctx.font_extents();
    let gap;
    if (ratio < 0) {
      gap = item.width + ratio * item.shrink;
    } else {
      gap = item.width + ratio * item.stretch;
    }
    if (style.background) {
      let color = normalizeColor(style.background)!;
      context.renderer.ctx.move_to(pos.x, pos.y);
      context.renderer.fillColor = color;
      context.renderer.rectangle(pos.x, pos.y, gap + 0.5, fe.height);
      context.renderer.fill();
    }
    return {
      width: gap,
      height: fe.height,
    };
  }

  private _drawItems(
    context: BuildContext,
    initPosition: PixelPosition,
    expectWidth: number
  ) {
    let inputItems = this._getInputItems(context);
    let breakpoints = this._getBreakpoints(context, expectWidth);
    let ratios = this._getAdjustmentRatios(context, expectWidth);
    let x = initPosition.x;
    let y = initPosition.y;

    for (let b = 0; b < breakpoints.length - 1; b++) {
      const start = b === 0 ? breakpoints[0] : breakpoints[b] + 1;
      let lineHeight = 0;
      for (let p = start; p <= breakpoints[b + 1]; p++) {
        let boxSize;
        if (inputItems[p].type === "box") {
          let item = inputItems[p] as Box;
          boxSize = this._drawBox(context, item, {
            x,
            y,
          });
        } else if (
          inputItems[p].type === "glue" &&
          p !== start &&
          p !== breakpoints[b + 1]
        ) {
          let item = inputItems[p] as Glue;
          boxSize = this._drawGlue(context, item, { x, y }, ratios[b]);
        }
        if (boxSize) {
          x += boxSize.width;
          lineHeight = Math.max(lineHeight, boxSize.height);
        }
      }
      x = initPosition.x;
      y += lineHeight;
    }
    // write the last line
    {
      const start = breakpoints[breakpoints.length - 1] + 1;
      let lineHeight = 0;
      for (let p = start; p < inputItems.length; p++) {
        let boxSize;
        if (inputItems[p].type === "box") {
          let item = inputItems[p] as Box;
          boxSize = this._drawBox(context, item, {
            x,
            y,
          });
        } else if (inputItems[p].type === "glue" && p !== start) {
          let item = inputItems[p] as Glue;
          boxSize = this._drawGlue(context, item, { x, y }, 0);
        }
        if (boxSize) {
          x += boxSize.width;
          lineHeight = Math.max(lineHeight, boxSize.height);
        }
      }
      if (start < inputItems.length) {
        x = initPosition.x;
        y += lineHeight;
      }
    }
    return y;
  }

  build(context: BuildContext): void {
    let expectWidth = this._renderBox!.width;
    this._drawItems(context, this._renderBox!.position, expectWidth);
  }
}

/**
 * A text paragraph.
 */
export function Text(opts: _TextOpts): Widget {
  return new _Text(opts);
}
