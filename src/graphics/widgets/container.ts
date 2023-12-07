import { BuildContext, Widget, _WidgetOption } from "@glib/widget";
import {
  AnyColor,
  BorderOptions,
  Color,
  ColorNormalizeResult,
  normalizeColor,
} from "./_utils";
import { isNil } from "@core/vim";
import { PixelSize, SizePolicy } from "@glib/base";

export interface _ContainerOpts extends _WidgetOption {
  /**
   * @description The height of the container.
   */
  height?: number;
  /**
   * @description The height policy of the container.
   */
  heightPolicy?: SizePolicy;
  /**
   * @description The width of the container.
   */
  width?: number;
  /**
   * @description The width policy of the container.
   */
  widthPolicy?: SizePolicy;
  /**
   * @description The border of the container.
   */
  border?: BorderOptions;
  /**
   * @description The background color of the container.
   */
  color?: AnyColor;
  /**
   * @description The child widget of the container.
   */
  child?: Widget;
}

export class _Container extends Widget {
  private _height?: number;
  private _width?: number;
  private _widthPolicy: SizePolicy;
  private _heightPolicy: SizePolicy;
  private _border?: ColorNormalizeResult<BorderOptions, "color">;
  private _color: Color;
  private _child?: Widget;

  constructor(opts: _ContainerOpts) {
    super(opts);

    this._height = opts.height;
    this._width = opts.width;
    if (opts.width) {
      this._widthPolicy = "fixed";
    } else {
      this._widthPolicy = opts.widthPolicy ?? "shrink";
    }
    if (opts.height) {
      this._heightPolicy = "fixed";
    } else {
      this._heightPolicy = opts.heightPolicy ?? "shrink";
    }
    if (opts.border) {
      this._border = {
        radius: opts.border.radius,
        width: opts.border.width,
        color: normalizeColor(opts.border.color),
      };
    }
    this._color = normalizeColor(opts.color) ?? Color.transparent;
    this._child = opts.child;
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

  override selectWidth(widthRange: [number, number]): number {
    if (this._widthPolicy === "fixed") {
      return this._width!;
    }
    if (this._widthPolicy === "expand") {
      return widthRange[1];
    }
    if (this._widthPolicy === "shrink") {
      return widthRange[0];
    }
    throw new Error(`Unknown width policy: ${this._widthPolicy}`);
  }

  override selectHeight(heightRange: [number, number]): number {
    if (this._heightPolicy === "fixed") {
      return this._height!;
    }
    if (this._heightPolicy === "expand") {
      return heightRange[1];
    }
    if (this._heightPolicy === "shrink") {
      return heightRange[0];
    }
    throw new Error(`Unknown height policy: ${this._heightPolicy}`);
  }

  guessWidthRange(): [number, PixelSize] {
    /// fixed width
    if (this._widthPolicy === "fixed") {
      return [this._width!, this._width!];
    }
    if (this._child) {
      let [min, _] = this._child.guessWidthRange();
      if (this._widthPolicy === "expand") {
        // as big as possible
        return [min, "inf"];
      }
      if (this._widthPolicy === "shrink") {
        // as small as possible
        return [min, min];
      }
    }
    return [0, "inf"];
  }

  guessHeightRange(): [number, PixelSize] {
    /// fixed height
    if (this._heightPolicy === "fixed") {
      return [this._height!, this._height!];
    }
    if (this._child) {
      let [min, _] = this._child.guessHeightRange();
      if (this._heightPolicy === "expand") {
        // as big as possible
        return [min, "inf"];
      }
      if (this._heightPolicy === "shrink") {
        // as small as possible
        return [min, min];
      }
    }
    return [0, "inf"];
  }

  get width(): number {
    if (isNil(this._renderBox)) {
      throw new Error("Render box is not set.");
    }
    return this._renderBox.width;
  }

  get height(): number {
    if (isNil(this._renderBox)) {
      throw new Error("Render box is not set.");
    }
    return this._renderBox.height;
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
    if (this._child) {
      context.build(this._child);
    }
  }
}

export function Container(opts: _ContainerOpts) {
  return new _Container(opts);
}
