import { isNil } from "@core/vim";
import { PixelPosition, PixelSize, RenderBox, sizeMax, sizeMin } from "./base";
import { CairoRender } from "./cairo-render";
import {
  Margin,
  MarginOptions,
  Padding,
  PaddingOptions,
} from "./widgets/_utils/common-options";
import { randv4 } from "@core/utils/uuid";
import { info } from "@core/utils/logger";

export class BuildContext {
  public renderer: CairoRender;
  public _rendering: Widget[] = [];
  public key: string = randv4();

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
    let parentRB;
    if (widget.parent) {
      parentRB = widget.parent._renderBox!;
    } else {
      parentRB = {
        contextKey: this.key,
        position: {
          x: 0,
          y: 0,
        },
        width: this.renderer.width,
        height: this.renderer.height,
      };
    }
    this._setupRenderBox(widget, parentRB);
    info(
      "Setup render box for widget: %s, %s",
      widget.key,
      vim.inspect(widget.renderBox)
    );
    widget.build(this);
  }

  private _setupRenderBox(widget: Widget, parent: RenderBox) {
    if (widget._renderBox && widget._renderBox.contextKey === this.key) {
      return widget._renderBox;
    }

    let widthMargin = widget.margin.left + widget.margin.right;
    let heightMargin = widget.margin.top + widget.margin.bottom;
    if (widthMargin > parent.width || heightMargin > parent.height) {
      throw new Error("Margin is larger than size.");
    }

    let width = parent.width - widthMargin;
    let height = parent.height - heightMargin;
    let position: PixelPosition = {
      x: parent.position.x + widget.margin.left,
      y: parent.position.y + widget.margin.top,
    };
    if (widget.parent) {
      position.x += widget.parent.padding.left;
      position.y += widget.parent.padding.top;
      width -= widget.parent.padding.left + widget.parent.padding.right;
      height -= widget.parent.padding.top + widget.parent.padding.bottom;
    }
    if (width < 0 || height < 0) {
      throw new Error("Padding is larger than size.");
    }

    // now, the max width and height has been calculated

    let widthRange = widget.guessWidthRange();
    let heightRange = widget.guessHeightRange();

    widthRange[1] = sizeMin(widthRange[1], width);
    heightRange[1] = sizeMin(heightRange[1], height);

    width = widget.selectWidth(widthRange);
    height = widget.selectHeight(heightRange);

    let box = {
      contextKey: this.key,
      position,
      width,
      height,
    };
    widget._renderBox = box;
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

export type WidgetKey = string;

export abstract class Widget {
  _renderBox: RenderBox | null = null;

  readonly key: WidgetKey = randv4();

  private _parent?: Widget;
  padding: PaddingOptions = Padding.zero;
  margin: MarginOptions = Margin.zero;

  constructor(opts?: _WidgetOption) {
    if (opts?.padding) {
      this.padding = opts.padding;
    }
    if (opts?.margin) {
      this.margin = opts.margin;
    }
  }

  get renderBox() {
    return this._renderBox;
  }

  get position(): PixelPosition {
    if (isNil(this.renderBox)) {
      throw new Error("Render box is not set.");
    }
    return this._renderBox!.position;
  }

  get parent() {
    return this._parent;
  }
  set parent(value: Widget | undefined) {
    this._parent = value;
  }

  /**
   * @description Render the widget.
   */
  abstract build(context: BuildContext): void;

  /**
   * @description Guess the width range of the widget.
   */
  abstract guessWidthRange(): [number, PixelSize];

  /**
   * @description Guess the height range of the widget.
   */
  abstract guessHeightRange(): [number, PixelSize];

  abstract selectHeight(heightRange: [number, PixelSize]): number;

  abstract selectWidth(widthRange: [number, PixelSize]): number;

  /**
   * @description Check if the widget can be rendered.
   */
  canRender(): boolean {
    return true;
  }
}
