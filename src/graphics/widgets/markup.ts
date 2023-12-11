import { info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import { FlexibleRange, RenderBox } from "@glib/base";
import { BuildContext } from "@glib/build-context";
import { Widget, WidgetKind, _WidgetPaddingMargin } from "@glib/widget";
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
    layout.set_width(width * lgi.Pango.SCALE);
    context.renderer.ctx.move_to(
      this._renderBox!.position.x,
      this._renderBox!.position.y
    );
    lgi.PangoCairo.show_layout(context.renderer.ctx, layout);
  }

  _widthRange(
    _context: BuildContext,
    maxAvailable: number,
    _determinedHeight?: number | undefined
  ): FlexibleRange {
    if (isNil(this.width)) {
      return {
        min: 0,
        max: maxAvailable,
      };
    } else {
      return {
        min: this.width,
        max: this.width,
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
    determinedWidth?: number | undefined
  ): FlexibleRange {
    let layout = this._getLayout(context);
    let width = ifNil(this.width, determinedWidth, -1);
    layout.set_width(width * lgi.Pango.SCALE);
    let [pixelWidth, pixelHeight] = layout.get_pixel_size();
    info("width: %s, height: %s", pixelWidth, pixelHeight);
    return {
      min: pixelHeight,
      max: "inf",
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
