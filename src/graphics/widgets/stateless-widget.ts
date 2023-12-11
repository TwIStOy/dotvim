import { isNil } from "@core/vim";
import { FlexibleRange, RenderBox } from "@glib/base";
import { BuildContext } from "@glib/build-context";
import {
  Widget,
  WidgetKind,
  WidgetSizeHint,
  _WidgetOption,
  _WidgetPaddingMargin,
} from "@glib/widget";

export abstract class StatelessWidget extends Widget {
  override readonly kind: WidgetKind = "StatelessWidget";

  private widgetCache?: {
    widget: Widget;
    contextKey: string;
  };

  constructor(opts: _WidgetOption & _WidgetPaddingMargin) {
    super(opts);
  }

  abstract intoWidget(context: BuildContext): Widget;

  isDirty(_context: BuildContext): boolean {
    return false;
  }

  private getWidget(context: BuildContext) {
    if (
      isNil(this.widgetCache) ||
      this.widgetCache.contextKey !== context.key ||
      this.isDirty(context)
    ) {
      this.widgetCache = {
        widget: this.intoWidget(context),
        contextKey: context.key,
      };
    }
    return this.widgetCache.widget;
  }

  build(context: BuildContext): void {
    let inner = this.getWidget(context);
    inner.build(context);
  }

  _widthRange(
    context: BuildContext,
    maxAvailable: number,
    determinedHeight?: number | undefined
  ): WidgetSizeHint {
    let inner = this.getWidget(context);
    return inner._widthRange(context, maxAvailable, determinedHeight);
  }

  _heightRange(
    context: BuildContext,
    maxAvailable: number,
    determinedWidth?: number | undefined
  ): WidgetSizeHint {
    let inner = this.getWidget(context);
    return inner._heightRange(context, maxAvailable, determinedWidth);
  }

  calculateRenderBox(
    context: BuildContext,
    inheritBox?: RenderBox | undefined
  ): void {
    let inner = this.getWidget(context);
    inner.calculateRenderBox(context, inheritBox);
  }
}
