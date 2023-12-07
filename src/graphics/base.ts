export type FlexibleSize = number | "inf";

export function sizeMin(a: FlexibleSize, b: FlexibleSize): FlexibleSize {
  if (a === "inf") return b;
  if (b === "inf") return a;
  return math.min(a, b);
}

export function sizeMax(a: FlexibleSize, b: FlexibleSize): FlexibleSize {
  if (a === "inf") return a;
  if (b === "inf") return b;
  return math.max(a, b);
}

export type SizePolicy = "fixed" | "expand" | "shrink";

export interface PixelPosition {
  /**
   * @description The x position of the pixel.
   */
  x: number;
  /**
   * @description The y position of the pixel.
   */
  y: number;
}

export interface RenderBox {
  /**
   * Key of `BuildContext` which the render box is from.
   */
  contextKey: string;

  position: PixelPosition;

  /**
   * Width of the box.
   */
  width: number;
  /**
   * Width of the box.
   */
  height: number;
}
