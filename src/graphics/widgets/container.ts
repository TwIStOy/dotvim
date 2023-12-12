import { ifNil, isNil } from "@core/vim";
import { RenderBox, sizeAdd, sizeMax, sizeMin } from "@glib/base";
import { BuildContext } from "@glib/build-context";
import {
  FlexiblePolicy,
  Widget,
  WidgetKind,
  WidgetSizeHint,
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

  private fitChildSize(
    context: BuildContext,
    key: "_width" | "_height",
    fn: "_widthRange" | "_heightRange",
    maxAvailable: number,
    determinedRhs?: number | undefined
  ): WidgetSizeHint {
    let value = this[key];
    if (typeof value === "number") {
      return {
        range: {
          min: value,
          max: value,
        },
        recommanded: value,
      };
    } else {
      if (!isNil(this._child)) {
        let c = this._child[fn](context, maxAvailable, determinedRhs);
        info("C, %s, max: %s", c, maxAvailable);
        // try to fix child's recommanded width or height
        let recommanded = c.recommanded;
        if (!isNil(recommanded) && recommanded > maxAvailable) {
          recommanded = undefined;
        }
        if (this[key] === "shrink") {
          // "shrink" means the size of `Containter` should be the same as its
          // child
          return {
            ...c,
            recommanded,
          };
        } else {
          return {
            range: {
              min: c.range.min,
              max: sizeMax(c.range.max, maxAvailable),
            },
            recommanded: maxAvailable,
          };
        }
      } else {
        return {
          range: {
            min: 0,
            max: maxAvailable,
          },
        };
      }
    }
  }

  _heightRange(
    context: BuildContext,
    maxAvailable: number,
    determinedWidth?: number | undefined
  ): WidgetSizeHint {
    let padding = this._padding.top + this._padding.bottom;
    let margin = this._margin.top + this._margin.bottom;
    let res = this.fitChildSize(
      context,
      "_height",
      "_heightRange",
      maxAvailable,
      determinedWidth
    );
    return {
      range: {
        min: res.range.min + padding + margin,
        max: sizeAdd(res.range.max, padding + margin),
      },
      recommanded: res.recommanded
        ? res.recommanded + padding + margin
        : undefined,
    };
  }

  _widthRange(
    context: BuildContext,
    maxAvailable: number,
    determinedHeight?: number | undefined
  ): WidgetSizeHint {
    let padding = this._padding.left + this._padding.right;
    let margin = this._margin.left + this._margin.right;
    let res = this.fitChildSize(
      context,
      "_width",
      "_widthRange",
      maxAvailable,
      determinedHeight
    );
    return {
      range: {
        min: res.range.min + padding + margin,
        max: sizeAdd(res.range.max, padding + margin),
      },
      recommanded: res.recommanded
        ? res.recommanded + padding + margin
        : undefined,
    };
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

    let width: number;
    let widthRange = this._widthRange(context, initBox.width);
    if (typeof this._width === "number") {
      width = this._width;
    } else if (!isNil(widthRange.recommanded)) {
      width = widthRange.recommanded;
    } else if (this._width === "shrink") {
      width = widthRange.range.min;
    } else {
      width = sizeMin(widthRange.range.max, initBox.width) as number;
    }
    info("w_range: %s, width: %s", widthRange, width);

    let height: number;
    let heightRange = this._heightRange(context, initBox.height);
    if (typeof this._height === "number") {
      height = this._height;
    } else if (!isNil(heightRange.recommanded)) {
      height = heightRange.recommanded;
    } else if (this._height === "shrink") {
      height = heightRange.range.min;
    } else {
      height = sizeMin(heightRange.range.max, initBox.height) as number;
    }
    info("h_range: %s, height: %s", heightRange, height);

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
    // info("Build box, %s", this._renderBox);

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

    // info("%s", tostring(this._border?.width));
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
