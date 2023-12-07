import { BuildContext, Widget, _WidgetOption } from "@glib/widget";
import {
  AnyColor,
  BorderOptions,
  Color,
  ColorNormalizeResult,
  normalizeColor,
} from "./_utils";
import { isNil } from "@core/vim";

export interface _ContainerOpts extends _WidgetOption {
  /**
   * @description The height of the container.
   */
  height?: number;
  /**
   * @description The width of the container.
   */
  width?: number;
  /**
   * @description The border of the container.
   */
  border?: BorderOptions;
  /**
   * @description The background color of the container.
   */
  color?: AnyColor;
}

export class _Container extends Widget {
  private _height?: number;
  private _width?: number;
  private _border?: ColorNormalizeResult<BorderOptions, "color">;
  private _color: Color;

  constructor(opts: _ContainerOpts) {
    super(opts);

    this._height = opts.height;
    this._width = opts.width;
    if (opts.border) {
      this._border = {
        radius: opts.border.radius,
        width: opts.border.width,
        color: normalizeColor(opts.border.color),
      };
    }
    this._color = normalizeColor(opts.color) ?? Color.transparent;
  }

  override canRender() {
    return this._hasBackground() || this._hasBorder();
  }

  private _hasBackground() {
    return this._color.alpha > 0;
  }

  private _hasBorder() {
    if (!this._border) {
      return false;
    }
    if (!this._border.color) {
      return false;
    }
    return this._border.color.alpha > 0 && this._border.width > 0;
  }

  get width() {
    if (isNil(this._width)) {
      // calculate width
    }
    return this._width ?? this.maxWidth;
  }

  get height() {
    return this._height ?? this.maxHeight;
  }

  override build(context: BuildContext) {
    if (!this._hasBorder()) {
      // simple rectangle
      context.renderer.rectangle(
        this.position.x,
        this.position.y,
        this.width,
        this.height
      );
      context.renderer.fillColor = this._color;
      context.renderer.fill();
    } else {
      // rounded rectangle
      context.renderer.roundedRectangle(
        this.position.x,
        this.position.y,
        this.width,
        this.height,
        this._border!.radius ?? 0
      );
      context.renderer.fillColor = this._color;
      context.renderer.fillPreserve();
      if (this._hasBorder()) {
        context.renderer.strokeColor = this._border!.color!;
        context.renderer.ctx.line_width(this._border!.width);
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
