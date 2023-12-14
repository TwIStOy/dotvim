import { info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import { RenderBox } from "@glib/base";
import { BuildContext } from "@glib/build-context";
import {
  Widget,
  WidgetKind,
  WidgetSizeHint,
  _WidgetPaddingMargin,
} from "@glib/widget";
import * as lgi from "lgi";

interface _MarkupOpts extends _WidgetPaddingMargin {
  /**
   * Pango markup string.
   */
  markup: string;
  /**
   * The max width of the markup.
   */
  width?: number;
}

class _Markup extends Widget {
  override readonly kind: WidgetKind = "Markup";
  private markup: string;
  private width?: number;

  private layoutCache?: {
    layout: lgi.Pango.Layout;
    contextKey: string;
  };

  constructor(opts: _MarkupOpts | string) {
    super({
      ...(type(opts) === "string" ? {} : (opts as _MarkupOpts)),
      flexible: "height",
      flexPolicy: "shrink",
    });
    if (typeof opts === "string") {
      this.markup = opts;
    } else {
      this.markup = opts.markup;
      this.width = opts.width;
    }
  }

  build(context: BuildContext): void {
    let width = ifNil(this.width, this._renderBox!.width);
    let layout = this._getLayout(context);
    width = width - this._padding.left - this._padding.right;
    layout.set_width(width * lgi.Pango.SCALE);
    context.renderer.ctx.move_to(
      this._renderBox!.position.x + this._padding.left,
      this._renderBox!.position.y + this._padding.top
    );
    lgi.PangoCairo.show_layout(context.renderer.ctx, layout);
    info("build markup: %s", vim.inspect(this.markup));
  }

  _widthRange(
    context: BuildContext,
    maxAvailable: number,
    _opts?: {
      determinedHeight?: number | undefined;
      depth?: number;
    }
  ): WidgetSizeHint {
    // try create the layout first to get the recommanded width
    let layout = lgi.PangoCairo.create_layout(context.renderer.ctx);
    layout.set_markup(this.markup, -1);
    layout.set_single_paragraph_mode(true);
    layout.set_width(-1);

    let [width, _height] = layout.get_pixel_size();

    if (isNil(this.width)) {
      return {
        range: {
          min: 0,
          max: maxAvailable,
        },
        recommanded: width + this._padding.left + this._padding.right,
      };
    } else {
      return {
        range: {
          min: this.width,
          max: this.width,
        },
        recommanded: width + this._padding.left + this._padding.right,
      };
    }
  }

  private _getLayout(context: BuildContext): lgi.Pango.Layout {
    if (
      !isNil(this.layoutCache) &&
      this.layoutCache.contextKey === context.key
    ) {
      return this.layoutCache.layout;
    }
    let layout = lgi.PangoCairo.create_layout(context.renderer.ctx);
    layout.set_markup(this.markup, -1);
    layout.set_single_paragraph_mode(true);
    this.layoutCache = {
      layout,
      contextKey: context.key,
    };
    return this._getLayout(context);
  }

  _heightRange(
    context: BuildContext,
    _maxAvailable: number,
    opts?: {
      determinedWidth?: number | undefined;
      depth?: number;
    }
  ): WidgetSizeHint {
    let layout = this._getLayout(context);
    let width = ifNil(this.width, opts?.determinedWidth, -1);
    if (isNil(width)) {
      width = -1;
    }
    if (width === -1) {
      layout.set_width(-1);
    } else {
      layout.set_width(width * lgi.Pango.SCALE);
    }

    let [pixelWidth, pixelHeight] = layout.get_pixel_size();
    info(
      "%slayout(%s, %s), when width is %s",
      " ".repeat((opts?.depth ?? 0) * 2),
      pixelWidth,
      pixelHeight,
      width
    );

    return {
      range: {
        min: pixelHeight + this._padding.top + this._padding.bottom,
        max: "inf",
      },
      recommanded: pixelHeight + this._padding.top + this._padding.bottom,
    };
  }

  calculateRenderBox(
    context: BuildContext,
    inheritBox?: RenderBox | undefined
  ): void {
    if (!inheritBox) {
      inheritBox = context.getInitialRenderBox();
    }
    let initBox = this.processMargin(inheritBox);
    this._renderBox = initBox;
  }
}

export function Markup(opts: _MarkupOpts | string): _Markup {
  return new _Markup(opts);
}
