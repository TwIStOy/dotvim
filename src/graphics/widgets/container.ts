import { ifNil } from "@core/vim";
import { FlexibleRange, RenderBox, sizeMax, sizeMin } from "@glib/base";
import { BuildContext } from "@glib/build-context";
import {
  FlexiblePolicy,
  Widget,
  WidgetKind,
  _WidgetPaddingMargin,
} from "@glib/widget";
import {
  AnyColor,
  BorderOptions,
  Color,
  ColorNormalizeResult,
  normalizeColor,
} from "./_utils";
import { info } from "@core/utils/logger";

interface _ContainerOpts extends _WidgetPaddingMargin {
  /**
   * @description The height of the container.
   */
  height?: number | FlexiblePolicy;
  /**
   * @description The width of the container.
   */
  width?: number | FlexiblePolicy;
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

class _Container extends Widget {
  override readonly kind: WidgetKind = "Container";

  private _height: number | FlexiblePolicy;
  private _width: number | FlexiblePolicy;
  private _border?: ColorNormalizeResult<BorderOptions, "color">;
  private _color: Color;
  private _child?: Widget;

  constructor(opts: _ContainerOpts) {
    super({
      ...opts,
      flexible: "none",
      flexPolicy: "shrink",
    });

    this._height = ifNil(opts.height, "shrink" as const);
    this._width = ifNil(opts.width, "shrink" as const);

    if (opts.border) {
      this._border = {
        radius: opts.border.radius,
        width: opts.border.width,
        color: normalizeColor(opts.border.color),
      };
      this._margin = {
        left: this._margin.left + opts.border.width / 2.0,
        right: this._margin.right + opts.border.width / 2.0,
        top: this._margin.top + opts.border.width / 2.0,
        bottom: this._margin.bottom + opts.border.width / 2.0,
      };
    }
    this._color = normalizeColor(opts.color) ?? Color.transparent;
    this._child = opts.child;
    if (this._child) {
      this._child.parent = this;
    }
  }

  override skipRender(): boolean {
    return !this._hasBackground() && !this._hasBorder();
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

  _heightRange(
    context: BuildContext,
    maxAvailable: number,
    determinedWidth?: number | undefined
  ): FlexibleRange {
    if (typeof this._height === "number") {
      return {
        min: this._height,
        max: this._height,
      };
    } else {
      let min, max;
      if (this._child) {
        let c = this._child._heightRange(
          context,
          maxAvailable,
          determinedWidth
        );
        if (this._height === "shrink") {
          min = c.min;
          max = c.max;
        } else {
          min = c.min;
          max = sizeMax(c.max, maxAvailable);
        }
        return { min, max };
      } else {
        return {
          min: 0,
          max: maxAvailable,
        };
      }
    }
  }

  _widthRange(
    context: BuildContext,
    maxAvailable: number,
    determinedHeight?: number | undefined
  ): FlexibleRange {
    if (typeof this._width === "number") {
      return {
        min: this._width,
        max: this._width,
      };
    } else {
      let min, max;
      if (this._child) {
        let c = this._child._widthRange(
          context,
          maxAvailable,
          determinedHeight
        );
        if (this._width === "shrink") {
          min = c.min;
          max = c.max;
        } else {
          min = c.min;
          max = sizeMax(c.max, maxAvailable);
        }
        return { min, max };
      } else {
        return {
          min: 0,
          max: maxAvailable,
        };
      }
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

    let widthRange = this._widthRange(context, initBox.width);
    let heightRange = this._heightRange(context, initBox.height);

    let width: number;
    if (typeof this._width === "number") {
      width = this._width;
    } else if (this._width === "shrink") {
      width = widthRange.min;
    } else {
      width = sizeMin(widthRange.max, initBox.width) as number;
    }

    let height: number;
    if (typeof this._height === "number") {
      height = this._height;
    } else if (this._height === "shrink") {
      height = heightRange.min;
    } else {
      height = sizeMin(heightRange.max, initBox.height) as number;
    }

    let myBox = {
      ...initBox,
      width,
      height,
    };
    this._renderBox = myBox;

    // process padding
    let paddingBox = this.processPadding(myBox);

    if (this._child) {
      this._child.calculateRenderBox(context, paddingBox);
    }
  }

  override build(context: BuildContext) {
    // // simple rectangle
    // context.renderer.rectangle(
    //   this._renderBox!.position.x,
    //   this._renderBox!.position.y,
    //   this._renderBox!.width,
    //   this._renderBox!.height
    // );
    // context.renderer.fillColor = this._color;
    // context.renderer.fill();

    // rounded rectangle, https://www.cairographics.org/samples/rounded_rectangle/
    let x = this._renderBox!.position.x;
    let y = this._renderBox!.position.y;
    let width = this._renderBox!.width;
    let height = this._renderBox!.height;
    let radius = (this._border?.radius ?? 0) / 1.0;
    let degress = Math.PI / 180.0;

    context.renderer.ctx.new_sub_path();
    context.renderer.ctx.arc(
      x + width - radius,
      y + radius,
      radius,
      -90 * degress,
      0
    );
    context.renderer.ctx.arc(
      x + width - radius,
      y + height - radius,
      radius,
      0,
      90 * degress
    );
    context.renderer.ctx.arc(
      x + radius,
      y + height - radius,
      radius,
      90 * degress,
      180 * degress
    );
    context.renderer.ctx.arc(
      x + radius,
      y + radius,
      radius,
      180 * degress,
      270 * degress
    );
    context.renderer.ctx.close_path();

    info("%s", tostring(this._border?.width));
    context.renderer.color = this._color;
    if (this._hasBorder()) {
      context.renderer.ctx.fill_preserve();
    } else {
      context.renderer.ctx.fill();
    }
    if (this._hasBorder()) {
      context.renderer.strokeColor = this._border!.color!;
      context.renderer.ctx.set_line_width(this._border!.width);
      context.renderer.stroke();
    }

    if (this._child) {
      this._child.build(context);
    }
  }
}

export function Container(opts: _ContainerOpts) {
  return new _Container(opts);
}
