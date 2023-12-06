import { CairoRender } from "./cairo-render";

export class BuildContext {
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

  build(widget: Widget) {
    let injection = this._prepareWidget();
    this.pushRendering(widget);
    widget.prepareBuild(injection);
    widget.build(this);
    this.popRendering();
  }

  private _prepareWidget() {
    let top = this._rendering[this._rendering.length - 1];
    let injection: BuildInjections;
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
}

interface BuildInjections {
  parent?: Widget;
  maxHeight: number;
  maxWidth: number;
  minHeight: number;
  minWidth: number;
}

export abstract class Widget {
  private buildInjections: BuildInjections | null = null;

  prepareBuild(injection: BuildInjections) {
    this.buildInjections = injection;
  }

  get maxHeight() {
    return this.buildInjections?.maxHeight ?? Infinity;
  }

  get maxWidth() {
    return this.buildInjections?.maxWidth ?? Infinity;
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
