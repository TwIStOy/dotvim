import { info } from "@core/utils/logger";
import { CairoRender } from "./cairo-render";
import {
  Margin,
  MarginOptions,
  Padding,
  PaddingOptions,
  PixelPosition,
} from "./widgets/_utils/common-options";

export class BuildContext implements graphics.BuildContext {
  public renderer: CairoRender;
  public _rendering: Widget[] = [];

  constructor(width: number, height: number) {
    this.renderer = new CairoRender(width, height);
  }

  pushRendering(widget: any) {
    this._rendering.push(widget);
  }

  popRendering() {
    this._rendering.pop();
  }

  build(widget: graphics.Widget) {
    let injection = this._prepareWidget();
    info("injection: %s", vim.inspect(injection));
    this.pushRendering(widget);
    widget.prepareBuild(injection);
    widget.build(this);
    this.popRendering();
  }

  private _prepareWidget() {
    let top = this._rendering[this._rendering.length - 1];
    let injection: graphics.BuildingInjections;
    if (!top) {
      injection = {
        maxHeight: this.renderer.height,
        maxWidth: this.renderer.width,
        minHeight: 0,
        minWidth: 0,
      };
    } else {
      injection = {
        maxHeight: top.maxHeight,
        maxWidth: top.maxWidth,
        minHeight: 0,
        minWidth: 0,
      };
    }
    return injection;
  }

  intoPngBytes(): number[] {
    return this.renderer.toPngBytes();
  }
}

export interface _WidgetOption {
  /**
   * @description The padding of the widget.
   */
  padding?: PaddingOptions;
  /**
   * @description The margin of the widget.
   */
  margin?: MarginOptions;
}

export abstract class Widget implements graphics.Widget {
  _injection: graphics.BuildingInjections | null = null;

  private _parent?: Widget;
  children: graphics.Widget[] = [];

  protected padding: PaddingOptions = Padding.zero;
  protected margin: MarginOptions = Margin.zero;
  protected position: PixelPosition = { x: 0, y: 0 };

  constructor(opts?: _WidgetOption) {
    if (opts?.padding) {
      this.padding = opts.padding;
    }
    if (opts?.margin) {
      this.margin = opts.margin;
    }
  }

  prepareBuild(injection: graphics.BuildingInjections) {
    this._injection = injection;
  }

  get maxHeight() {
    return this._injection?.maxHeight ?? Infinity;
  }

  get maxWidth() {
    return this._injection?.maxWidth ?? Infinity;
  }

  get parent() {
    return this._parent;
  }
  set parent(value: Widget | undefined) {
    this._parent = value;
    // update position
    if (value) {
      this.position.x =
        value.position.x + value.padding.left + this.margin.left;
      this.position.y = value.position.y + value.padding.top + this.margin.top;
    } else {
      this.position.x = this.margin.left;
      this.position.y = this.margin.top;
    }
  }

  /**
   * @description Render the widget.
   */
  abstract build(context: BuildContext): void;

  /**
   * @description Check if the widget can be rendered.
   */
  canRender(): boolean {
    return true;
  }
}
