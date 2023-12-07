import { BuildContext, Widget, _WidgetOption } from "@glib/widget";
import { AnyColor, Color, normalizeColor } from "../_utils";
import { FlexibleSize, PixelPosition } from "@glib/base";

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

interface _TextOpts extends _WidgetOption {
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

class _Text extends Widget {
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
    super(opts);

    if (type(opts.text) === "string") {
      this._text = [opts.text as string];
    } else {
      this._text = opts.text as string[];
    }
    if (opts.style) {
      this._style = {
        color: normalizeColor(opts.style.color) ?? Color.from("black"),
        fontFamily: opts.style.fontFamily ?? "Sans",
        fontSlant: opts.style.fontSlant ?? "normal",
        fontWeight: opts.style.fontWeight ?? "normal",
        fontSize: opts.style.fontSize ?? 12,
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

  private _setupFont(context: BuildContext) {
    context.renderer.ctx.font_face(
      this._style.fontFamily,
      this._style.fontSlant,
      this._style.fontWeight
    );
    context.renderer.ctx.font_size(this._style.fontSize);
  }

  build(context: BuildContext): void {
    this._setupFont(context);

    let fe = context.renderer.ctx.font_extents();
    let position: PixelPosition = {
      x: this.position.x,
      y: this.position.y + fe.height,
    };

    for (let line of this._text) {
      let chars = toUtfChars(line);
      for (let char of chars) {
        let te = context.renderer.ctx.text_extents(char);
        context.renderer.ctx.rgba(
          this._style.color.red,
          this._style.color.green,
          this._style.color.blue,
          this._style.color.alpha
        );
        context.renderer.ctx.move_to(position.x, position.y - fe.descent);
        context.renderer.ctx.show_text(char);
        position.x += te.x_advance;
      }
      position.x = this.position.x;
      position.y += fe.height;
    }
  }

  override get expandHeight(): boolean {
    return false;
  }

  override get expandWidth(): boolean {
    if (this._width === "inf") {
      return true;
    }
    return false;
  }

  guessWidthRange(_context: BuildContext): [number, FlexibleSize] {
    if (this._width === "inf") {
      return [0, "inf"];
    } else {
      return [this._width, this._width];
    }
  }

  guessHeightRange(context: BuildContext): [number, FlexibleSize] {
    context.renderer.ctx.font_face(
      this._style.fontFamily,
      this._style.fontSlant,
      this._style.fontWeight
    );
    context.renderer.ctx.font_size(this._style.fontSize);
    let fe = context.renderer.ctx.font_extents();
    return [fe.height, "inf"];
  }

  override selectSize(
    context: BuildContext,
    widthRange: [number, number],
    heightRange: [number, number]
  ): { width: number; height: number } {
    this._setupFont(context);
    let fe = context.renderer.ctx.font_extents();

    let width = widthRange[1];
    let expectHeight = 0;
    // sum all lines
    for (let line of this._text) {
      let chars = toUtfChars(line);
      let expectWidth = 0;
      for (let char of chars) {
        let te = context.renderer.ctx.text_extents(char);
        expectWidth += te.x_advance;
      }
      expectHeight = fe.height * Math.ceil(expectWidth / width);
    }
    return {
      width,
      height: Math.min(expectHeight, heightRange[1]),
    };
  }
}

export function Text(opts: _TextOpts): Widget {
  return new _Text(opts);
}
