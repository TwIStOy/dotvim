import { info } from "@core/utils/logger";
import { ifNil, isNil } from "@core/vim";
import {
  FlexibleRange,
  FlexibleSize,
  RenderBox,
  sizeAdd,
  sizeMax,
  sizeMin,
} from "@glib/base";
import { BuildContext } from "@glib/build-context";
import {
  Widget,
  WidgetKind,
  WidgetSizeHint,
  _WidgetOption,
} from "@glib/widget";

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
    let widthRange = this._widthRange(context, initBox.width);
    if (!isNil(widthRange.recommanded)) {
      width = widthRange.recommanded;
    } else if (useMaxWidth) {
      width = initBox.width;
    } else {
      let range = this._children.reduce(
        (previous: FlexibleRange, child: Widget): FlexibleRange => {
          let rg = child._widthRange(context, initBox.width);
          return {
            min: Math.min(previous.min, rg.range.min),
            max: sizeMax(previous.max, rg.range.max),
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
    let height;
    let heightRange = this._heightRange(context, initBox.height, width);
    for (let child of this._children) {
      if (
        child.kind !== "Spacing" &&
        child.isHeightFlexible() &&
        child._flexPolicy === "expand"
      ) {
        height = heightRange.range.max;
        break;
      }
    }
    if (isNil(height)) {
      if (heightRange.recommanded) {
        height = heightRange.recommanded;
      } else {
        height = heightRange.range.min;
      }
    }
    if (height === "inf") {
      height = initBox.height;
    }

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

    // width is determined, so we can calculate the fixed height.
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
        if (heightRange.recommanded) {
          return previous + heightRange.recommanded;
        } else {
          return previous + heightRange.range.min;
        }
      },
      0
    );

    this._renderBox = myBox;

    let spacingSize = Math.max(
      (paddingBox.height - fixedHeight) / spacingNum,
      0
    );

    // info(
    //   "Column %s spacings, height: %s, fixed: %s",
    //   spacingNum,
    //   spacingSize,
    //   fixedHeight
    // );
    //
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
      let height;
      if (heightRange.recommanded) {
        height = heightRange.recommanded;
      } else {
        height = heightRange.range.min;
      }
      let box: RenderBox = {
        ...paddingBox,
        position: {
          x: paddingBox.position.x,
          y: paddingBox.position.y + usedHeight,
        },
        height,
        width: paddingBox.width,
      };
      child.calculateRenderBox(context, box);
      usedHeight += height;
    }
  }

  override _widthRange(
    context: BuildContext,
    maxAvailable: number,
    determinedHeight?: number | undefined
  ): WidgetSizeHint {
    let minWidth = 0;
    let maxWidth: FlexibleSize = 0;
    let recommendedWidth: number | undefined;

    for (let child of this._children) {
      let range = child._widthRange(context, maxAvailable, determinedHeight);
      minWidth = Math.max(minWidth, range.range.min);
      maxWidth = sizeMax(maxWidth, range.range.max);
      if (!isNil(range.recommanded)) {
        recommendedWidth = Math.max(
          ifNil(recommendedWidth, 0),
          range.recommanded
        );
      }
    }
    maxWidth = sizeMin(maxWidth, maxAvailable);
    if (!isNil(recommendedWidth) && maxWidth != "inf") {
      if (recommendedWidth > maxWidth) {
        recommendedWidth = undefined;
      }
    }
    let padding = this._padding.left + this._padding.right;
    let res = {
      range: {
        min: minWidth + padding,
        max: sizeAdd(maxWidth, padding),
      },
      recommanded: recommendedWidth ? recommendedWidth + padding : undefined,
    };
    // info("Column guess width: %s", res);
    return res;
  }

  override _heightRange(
    _context: BuildContext,
    maxAvailable: number,
    determinedWidth?: number | undefined
  ): WidgetSizeHint {
    let minHeight = 0;
    let maxHeight: FlexibleSize = 0;
    let recommendedHeight: number[] = [];

    let childrenRanges = [];
    for (let child of this._children) {
      let range = child._heightRange(_context, maxAvailable, determinedWidth);
      minHeight += range.range.min;
      if (range.range.max === "inf") {
        maxHeight = "inf";
      } else {
        if (maxHeight !== "inf") {
          maxHeight += range.range.max;
        }
      }
      if (!isNil(range.recommanded)) {
        recommendedHeight.push(range.recommanded);
      }
      childrenRanges.push({
        range,
        kind: child.kind,
      });
    }

    let ret = {
      range: {
        min: minHeight,
        max: sizeMin(maxHeight, maxAvailable),
      },
      recommanded:
        recommendedHeight.length === this._children.length
          ? recommendedHeight.reduce(
              (previous: number, current: number): number => {
                return previous + current;
              }
            )
          : undefined,
    };
    return ret;
  }
}

export function Column(opts: _ColumnOpts) {
  return new _Column(opts);
}
