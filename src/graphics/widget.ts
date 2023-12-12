import { randv4 } from "@core/utils/uuid";
import { ifNil } from "@core/vim";
import { FlexibleRange, RenderBox } from "./base";
import { BuildContext } from "./build-context";
import {
  Margin,
  MarginOptions,
  Padding,
  PaddingOptions,
} from "./widgets/_utils/common-options";
import { info } from "@core/utils/logger";

export type FlexibleType = "none" | "width" | "height" | "both";

export type FlexiblePolicy = "expand" | "shrink";

export interface _WidgetOption {
  /**
   * @description Which direction the widget is flexible.
   *
   * - `none` means the widget has a fixed size.
   * - `width` means the widget can be as large as possible in width.
   * - `height` means the widget can be as large as possible in height.
   * - `both` means the widget can be as large as possible in both width and
   *   height.
   */
  flexible: FlexibleType;

  /**
   * If the widget is flexible, how it should be flexible. Default is `expand`.
   */
  flexPolicy?: FlexiblePolicy;
}

export interface _WidgetPaddingMargin {
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

export type WidgetKind =
  | "Container"
  | "Spacing"
  | "Column"
  | "Text"
  | "Markup"
  | "StatelessWidget";

export interface WidgetSizeHint {
  /**
   * @description The widget width should be in this range.
   */
  range: FlexibleRange;
  /**
   * @description The recommended width of the widget.
   */
  recommanded?: number;
}

export abstract class Widget {
  __renderBox: RenderBox | null = null;

  /**
   * @description The kind of the widget.
   */
  abstract readonly kind: WidgetKind;
  /**
   * @description The unique key of the widget.
   */
  readonly key: WidgetKey = randv4();

  /**
   * @description The parent of the widget.
   */
  private _parent?: Widget;

  _flexible: FlexibleType;
  _flexPolicy: FlexiblePolicy;

  _padding: PaddingOptions;
  _margin: MarginOptions;

  constructor(opts: _WidgetOption & _WidgetPaddingMargin) {
    this._flexible = ifNil(opts.flexible, "none" as const);
    this._flexPolicy = ifNil(opts.flexPolicy, "expand" as const);
    this._padding = ifNil(opts.padding, Padding.zero);
    this._margin = ifNil(opts.margin, Margin.zero);
  }

  get parent() {
    return this._parent;
  }

  set parent(value: Widget | undefined) {
    this._parent = value;
  }

  get _renderBox() {
    return this.__renderBox;
  }
  set _renderBox(value: RenderBox | null) {
    this.__renderBox = value;
  }

  /**
   * @description Render the widget.
   */
  abstract build(context: BuildContext): void;

  isHeightFlexible(): boolean {
    return this._flexible === "height" || this._flexible === "both";
  }

  isWidthFlexible(): boolean {
    return this._flexible === "width" || this._flexible === "both";
  }

  protected processMargin(box: RenderBox): RenderBox {
    return {
      ...box,
      position: {
        x: box.position.x + this._margin.left,
        y: box.position.y + this._margin.top,
      },
      width: box.width - this._margin.left - this._margin.right,
      height: box.height - this._margin.top - this._margin.bottom,
    };
  }

  protected processPadding(box: RenderBox): RenderBox {
    return {
      ...box,
      position: {
        x: box.position.x + this._padding.left,
        y: box.position.y + this._padding.top,
      },
      width: box.width - this._padding.left - this._padding.right,
      height: box.height - this._padding.top - this._padding.bottom,
    };
  }

  /**
   * @description Calculate the expected width range of the widget.
   *
   * If `determinedHeight` is provided, the width range will be calculated
   * based on the determined height.
   */
  abstract _widthRange(
    context: BuildContext,
    maxAvailable: number,
    determinedHeight?: number
  ): WidgetSizeHint;

  /**
   * @description Calculate the expected height range of the widget.
   *
   * If `determinedWidth` is provided, the height range will be calculated
   * based on the determined width.
   */
  abstract _heightRange(
    context: BuildContext,
    maxAvailable: number,
    determinedWidth?: number
  ): WidgetSizeHint;

  abstract calculateRenderBox(
    context: BuildContext,
    inheritBox?: RenderBox
  ): void;

  /**
   * @description Whether the widget should be rendered.
   */
  skipRender() {
    return false;
  }
}
