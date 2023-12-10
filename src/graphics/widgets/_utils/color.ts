import { info } from "@core/utils/logger";
import { isNil } from "@core/vim";

type BuiltinColor = "red" | "green" | "blue" | "white" | "black";
type RGB = `rgb(${number}, ${number}, ${number})`;
type RGBA = `rgba(${number}, ${number}, ${number}, ${number})`;
type Hex = `#${string}`;

export type ColorSource =
  | RGB
  | RGBA
  | Hex
  | BuiltinColor
  | number
  | [number, number, number]
  | [number, number, number, number];

export class Color {
  // all values are in the range [0, 1]
  private _red: number;
  private _green: number;
  private _blue: number;
  private _alpha: number;

  static transparent = new Color(0, 0, 0, 0);

  static from(source: ColorSource) {
    // hex number
    if (typeof source === "number") {
      return Color.fromHex(source);
    }
    // builtin
    if (source === "red") {
      return Color.fromHex(0xff0000);
    } else if (source === "green") {
      return Color.fromHex(0x00ff00);
    } else if (source === "blue") {
      return Color.fromHex(0x0000ff);
    } else if (source === "white") {
      return Color.fromHex(0xffffff);
    } else if (source === "black") {
      return Color.fromHex(0x000000);
    }
    if (Array.isArray(source)) {
      if (source.length === 3) {
        return Color.fromRGBA(source[0], source[1], source[2], 1.0);
      } else if (source.length === 4) {
        return Color.fromRGBA(source[0], source[1], source[2], source[3]);
      }
    }
    // hex string
    if (source.startsWith("#")) {
      const hex = tonumber(source.slice(1), 16) ?? 0;
      return Color.fromHex(hex);
    }
    // rgb
    // TODO(hawtian): Add support for `rgb(255, 255, 255)` and `rgba(255, 255, 255, 1.0)`.
    return Color.fromHex(0);
  }

  private static fromHex(hex: number) {
    if (hex > 0xffffff) {
      return Color._from32BitHex(hex);
    }
    return Color._from24BitHex(hex);
  }

  private static _from24BitHex(hex: number) {
    if (hex > 0xffffff) {
      throw new Error(`Invalid hex value: ${hex}`);
    }
    const red = ((hex >> 16) & 0xff) / 255;
    const green = ((hex >> 8) & 0xff) / 255;
    const blue = (hex & 0xff) / 255;
    return new Color(red, green, blue, 1.0);
  }

  private static _from32BitHex(hex: number) {
    if (hex > 0xffffffff) {
      throw new Error(`Invalid hex value: ${hex}`);
    }
    const red = ((hex >> 24) & 0xff) / 255;
    const green = ((hex >> 16) & 0xff) / 255;
    const blue = ((hex >> 8) & 0xff) / 255;
    const alpha = (hex & 0xff) / 255;
    return new Color(red, green, blue, alpha);
  }

  private static fromRGBA(
    red: number,
    green: number,
    blue: number,
    alpha: number
  ) {
    if (!Color._isValid(red)) {
      throw new Error(`Invalid red value: ${red}`);
    }
    if (!Color._isValid(green)) {
      throw new Error(`Invalid green value: ${green}`);
    }
    if (!Color._isValid(blue)) {
      throw new Error(`Invalid blue value: ${blue}`);
    }
    if (!Color._isValid(alpha)) {
      throw new Error(`Invalid alpha value: ${alpha}`);
    }
    return new Color(red, green, blue, alpha);
  }

  private constructor(red: number, green: number, blue: number, alpha: number) {
    this._red = red;
    this._green = green;
    this._blue = blue;
    this._alpha = alpha;
  }

  private static _isValid(value: number) {
    return value >= 0 && value <= 1;
  }

  get red() {
    return this._red;
  }
  set red(value: number) {
    this._red = value;
  }

  get green() {
    return this._green;
  }
  set green(value: number) {
    this._green = value;
  }

  get blue() {
    return this._blue;
  }
  set blue(value: number) {
    this._blue = value;
  }

  get alpha() {
    return this._alpha;
  }
  set alpha(value: number) {
    this._alpha = value;
  }
}

export type AnyColor = Color | ColorSource;

export function normalizeColor(color?: AnyColor) {
  if (isNil(color)) {
    return undefined;
  }
  if (color instanceof Color) {
    return color;
  }
  return Color.from(color);
}

export type ColorNormalizeResult<T, K extends keyof T> = Omit<T, K> & {
  [P in K]: Color | undefined;
};
