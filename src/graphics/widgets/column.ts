import { FlexibleSize, sizeMax } from "@glib/base";
import { BuildContext, Widget, _WidgetOption } from "@glib/widget";

interface _ColumnOpts extends _WidgetOption {
  children: Widget[];
}

class _Column extends Widget {
  private _children: Widget[];

  constructor(opts: _ColumnOpts) {
    super(opts);
    this._children = opts.children;
  }

  build(context: BuildContext): void {
    for (let child of this._children) {
      child.build(context);
    }
  }

  override get expandHeight(): boolean {
    return this._children.some((child) => child.expandHeight);
  }

  override get expandWidth(): boolean {
    return false;
  }

  guessWidthRange(): [number, FlexibleSize] {
    let minWidth = 0;
    let maxWidth: FlexibleSize = 0;

    for (let child of this._children) {
      let [min, max] = child.guessWidthRange();
      minWidth = Math.max(minWidth, min);
      maxWidth = sizeMax(maxWidth, max);
    }
    return [minWidth, maxWidth];
  }

  guessHeightRange(): [number, FlexibleSize] {
    throw new Error("Method not implemented.");
  }

  selectHeight(heightRange: [number, number]): number {
    if (this.expandHeight) {
      return heightRange[1];
    }
    return heightRange[0];
  }

  selectWidth(widthRange: [number, number]): number {
    return widthRange[0];
  }
}

export function Column(opts: _ColumnOpts) {
  return new _Column(opts);
}
