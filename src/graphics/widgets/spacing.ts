import { RenderBox } from "@glib/base";
import { FlexibleType, Widget, WidgetKind, WidgetSizeHint } from "@glib/widget";
import { ifNil, isNil } from "@core/vim";
import { BuildContext } from "@glib/build-context";

interface _SpacingOpts {
  /**
   * @description The height of the spacing.
   */
  height?: number;
  /**
   * @description The width of the spacing.
   */
  width?: number;
}

class _Spacing extends Widget {
  override readonly kind: WidgetKind = "Spacing";
  private _width?: number;
  private _height?: number;

  constructor(opts: _SpacingOpts) {
    let flexible: FlexibleType = "none";
    if (isNil(opts.width)) {
      flexible = "width";
    }
    if (isNil(opts.height)) {
      if (flexible === "width") {
        flexible = "both";
      } else {
        flexible = "height";
      }
    }
    super({
      flexible,
      flexPolicy: "expand",
    });

    this._width = opts.width;
    this._height = opts.height;
  }

  build(_context: BuildContext): void {
    // do nothing
  }

  _widthRange(
    _context: BuildContext,
    maxAvailable: number,
    _determinedHeight?: number | undefined
  ): WidgetSizeHint {
    if (isNil(this._width)) {
      return {
        range: {
          min: 0,
          max: maxAvailable,
        },
      };
    } else {
      return {
        range: {
          min: this._width,
          max: this._width,
        },
      };
    }
  }

  _heightRange(
    _context: BuildContext,
    maxAvailable: number,
    _determinedWidth?: number | undefined
  ): WidgetSizeHint {
    if (isNil(this._height)) {
      return {
        range: {
          min: 0,
          max: maxAvailable,
        },
      };
    } else {
      return {
        range: {
          min: this._height,
          max: this._height,
        },
      };
    }
  }

  calculateRenderBox(
    _context: BuildContext,
    _inheritBox?: RenderBox | undefined
  ): void {
    // do nothing
    this._renderBox = _inheritBox!;
  }
}

export function Spacing(opts?: _SpacingOpts): Widget {
  return new _Spacing(ifNil(opts, {}));
}
