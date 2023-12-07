import { BuiltinColor, Color } from "@glib/color";
import { BuildContext, Widget } from "@glib/widget";

export interface _ContainerBorderOpts {
  /**
   * @description The border radius of the container.
   */
  radius?: number;
  /**
   * @description The border width of the container.
   */
  lineWidth?: number;
  /**
   * @description The border color of the container.
   */
  color?: Color;
}

export interface _ContainerOpts {
  /**
   * @description The height of the container.
   */
  height?: number;
  /**
   * @description The width of the container.
   */
  width?: number;
  /**
   * @description The border width of the container.
   */
  border?: _ContainerBorderOpts;
  /**
   * @description The background color of the container.
   */
  backgroundColor?: Color | string | BuiltinColor;
}

export class _Container extends Widget {
  private _height?: number;
  private _width?: number;
  private _border?: {
    radius?: number;
    lineWidth?: number;
    color?: Color;
  };
  private _backgroundColor: Color;

  constructor(opts: _ContainerOpts) {
    super();

    this._height = opts.height;
    this._width = opts.width;
    this._border = opts.border;
    if (typeof opts.backgroundColor === "string") {
      this._backgroundColor = Color.fromStr(opts.backgroundColor);
    } else {
      this._backgroundColor =
        opts.backgroundColor ?? Color.fromRGBA(0, 0, 0, 0);
    }
  }

  override canRender() {
    return (
      this._backgroundColor.alpha === 0 &&
      (this._border?.color?.alpha ?? 0) === 0
    );
  }

  get width() {
    return this._width ?? this.maxWidth;
  }

  get height() {
    return this._height ?? this.maxHeight;
  }

  override build(context: BuildContext) {
    if (!this._border) {
      // simple rectangle
      context.renderer.rectangle(0, 0, this.width, this.height);
      context.renderer.fillColor = this._backgroundColor;
      context.renderer.fill();
    } else {
      // rounded rectangle
      context.renderer.roundedRectangle(
        0,
        0,
        this.width,
        this.height,
        this._border.radius ?? 0
      );
      context.renderer.fillColor = this._backgroundColor;
      context.renderer.fillPreserve();
      if (this._border.lineWidth && (this._border.color?.alpha ?? 0 > 0)) {
        context.renderer.strokeColor = this._border.color!;
        context.renderer.ctx.line_width(this._border.lineWidth);
        context.renderer.stroke();
      }
    }
  }
}

export function Container(opts: _ContainerOpts, ...children: Widget[]) {
  let widget = new _Container(opts);
  widget.children = children;
  return widget;
}
