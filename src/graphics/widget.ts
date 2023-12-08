import { isNil } from "@core/vim";
import { PixelPosition, FlexibleSize, RenderBox, sizeMin } from "./base";
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
  public key: string;

  constructor(width: number, height: number) {
    this.renderer = new CairoRender(width, height);
    this.key = randv4();
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
      "Setup render box for widget: (%s, %s), parent: %s, %s",
      widget.kind,
      widget.key,
      widget.parent?.key,
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

    let widthRange = widget.guessWidthRange(this);
    let heightRange = widget.guessHeightRange(this);

    widthRange[1] = sizeMin(widthRange[1], width);
    heightRange[1] = sizeMin(heightRange[1], height);

    let size = widget.selectSize(
      this,
      widthRange as [number, number],
      heightRange as [number, number]
    );

    let box = {
      contextKey: this.key,
      position,
      width: size.width,
      height: size.height,
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

  abstract readonly kind: string;
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
  abstract guessWidthRange(context: BuildContext): [number, FlexibleSize];

  /**
   * @description Guess the height range of the widget.
   */
  abstract guessHeightRange(context: BuildContext): [number, FlexibleSize];

  abstract selectSize(
    context: BuildContext,
    widthRange: [number, number],
    heightRange: [number, number]
  ): {
    width: number;
    height: number;
  };

  /**
   * @description Check if the widget can be rendered.
   */
  canRender(): boolean {
    return true;
  }

  /**
   * @description Returns if the widget expect to be as large as possible in height.
   */
  abstract get expandHeight(): boolean;

  /**
   * @description Returns if the widget expect to be as large as possible in width.
   */
  abstract get expandWidth(): boolean;
}
