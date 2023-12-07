export type BuiltinColor = "red" | "green" | "blue";
export class Color {
  // all values are in the range [0, 1]
  private _red: number;
  private _green: number;
  private _blue: number;
  private _alpha: number;

  static fromHex(hex: number) {
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

  static fromStr(s: string | BuiltinColor) {
    if (s.startsWith("#")) {
      return Color.fromHex(tonumber(s.slice(1), 16)!);
    }
    if (s === "red") {
      return Color.fromHex(0xff0000);
    } else if (s === "green") {
      return Color.fromHex(0x00ff00);
    } else if (s === "blue") {
      return Color.fromHex(0x0000ff);
    }
    return Color.fromHex(0);
  }

  static fromRGBA(red: number, green: number, blue: number, alpha: number) {
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
