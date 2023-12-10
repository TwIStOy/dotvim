import { info } from "@core/utils/logger";
import { FlexibleRange, FlexibleSize, RenderBox, sizeMax } from "@glib/base";
import { BuildContext } from "@glib/build-context";
import { Widget, WidgetKind, _WidgetOption } from "@glib/widget";

interface _ColumnOpts {
  children: Widget[];
}

class _Column extends Widget {
  override readonly kind: WidgetKind = "Column";

  private _children: Widget[];

  constructor(opts: _ColumnOpts) {
    let policy: "shrink" | "expand" = "shrink";
    for (let child of opts.children) {
      if (child._flexible === "height" && child._flexPolicy === "expand") {
        policy = "expand" as const;
        break;
      }
    }
    super({
      flexible: "height",
      flexPolicy: policy,
    });
    this._children = opts.children;
  }

  build(context: BuildContext): void {
    for (let child of this._children) {
      child.build(context);
    }
  }

  override calculateRenderBox(
    context: BuildContext,
    inheritBox?: RenderBox
  ): void {
    if (!inheritBox) {
      inheritBox = context.getInitialRenderBox();
    }

    // reducing current box from magin first.
    let initBox = this.processMargin(inheritBox);

    // Calculate `Column`'s width. A `Column` is height flexible, so the width
    // is the max width of its children.
    let useMaxWidth = this._children.some((child: Widget): boolean => {
      if (child._flexible === "width" && child._flexPolicy === "expand") {
        return true;
      }
      return false;
    });
    let width: number;
    if (useMaxWidth) {
      width = initBox.width;
    } else {
      let range = this._children.reduce(
        (previous: FlexibleRange, child: Widget): FlexibleRange => {
          let rg = child._widthRange(context, initBox.width);
          return {
            min: Math.min(previous.min, rg.min),
            max: sizeMax(previous.max, rg.max),
          };
        },
        {
          min: 0,
          max: 0,
        }
      );
      if (range.max === "inf") {
        width = initBox.width;
      } else {
        width = range.max;
      }
    }

    // Calculate `Column`'s height. A `Column` is height flexible, so the height
    // is trying to fix the max available height, even all its children have the
    // fixed height.
    let height = initBox.height;

    let myBox = {
      ...initBox,
      height,
      width,
    };

    // Process padding, its children will be placed in the padding box.
    let paddingBox = this.processPadding(myBox);

    let spacingNum = this._children.reduce(
      (previous: number, child: Widget): number => {
        if (child.kind === "Spacing" && child.isHeightFlexible()) {
          return previous + 1;
        }
        return previous;
      },
      0
    );

    let fixedHeight = this._children.reduce(
      (previous: number, child: Widget): number => {
        if (child.kind === "Spacing" && child.isHeightFlexible()) {
          return previous;
        }
        let heightRange = child._heightRange(
          context,
          paddingBox.height,
          paddingBox.width
        );
        return previous + heightRange.min;
      },
      0
    );

    this._renderBox = myBox;

    let spacingSize = Math.max(
      (paddingBox.height - fixedHeight) / spacingNum,
      0
    );

    info(
      "Column %s spacings, height: %s, fixed: %s",
      spacingNum,
      spacingSize,
      fixedHeight
    );

    let usedHeight = 0;
    for (let child of this._children) {
      if (child.kind === "Spacing" && child.isHeightFlexible()) {
        usedHeight += spacingSize;
        continue;
      }
      let heightRange = child._heightRange(
        context,
        paddingBox.height,
        paddingBox.width
      );
      let box: RenderBox = {
        ...paddingBox,
        position: {
          x: paddingBox.position.x,
          y: paddingBox.position.y + usedHeight,
        },
        height: heightRange.min,
        width: paddingBox.width,
      };
      child.calculateRenderBox(context, box);
      usedHeight += heightRange.min;
    }
  }

  override _widthRange(
    context: BuildContext,
    maxAvailable: number,
    determinedHeight?: number | undefined
  ): FlexibleRange {
    let minWidth = 0;
    let maxWidth: FlexibleSize = 0;

    for (let child of this._children) {
      let range = child._widthRange(context, maxAvailable, determinedHeight);
      minWidth = Math.max(minWidth, range.min);
      maxWidth = sizeMax(maxWidth, range.max);
    }
    return {
      min: minWidth,
      max: maxWidth,
    };
  }

  override _heightRange(
    _context: BuildContext,
    maxAvailable: number,
    _determinedWidth?: number | undefined
  ): FlexibleRange {
    return {
      min: maxAvailable,
      max: maxAvailable,
    };
  }
}

export function Column(opts: _ColumnOpts) {
  return new _Column(opts);
}
