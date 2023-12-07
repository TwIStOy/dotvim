import { info } from "@core/utils/logger";
import { CairoRender } from "./cairo-render";

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
        parent: top,
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

export abstract class Widget implements graphics.Widget {
  _injection: graphics.BuildingInjections | null = null;
  children: graphics.Widget[] = [];

  prepareBuild(injection: graphics.BuildingInjections) {
    this._injection = injection;
  }

  get maxHeight() {
    return this._injection?.maxHeight ?? Infinity;
  }

  get maxWidth() {
    return this._injection?.maxWidth ?? Infinity;
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
