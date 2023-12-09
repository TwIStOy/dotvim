import * as cairo from "ht.clib.cairo";
import { debug_ } from "@core/utils/logger";
import { AnyColor, Color, normalizeColor } from "./widgets/_utils/color";

export type CompositeOperation =
  | "source-over"
  | "source-in"
  | "source-out"
  | "source-atop"
  | "destination-over"
  | "destination-in"
  | "destination-out"
  | "destination-atop"
  | "xor"
  | "color"
  | "color-burn"
  | "color-dodge"
  | "darken"
  | "difference"
  | "exclusion"
  | "hard-light"
  | "hue"
  | "lighten"
  | "lighter"
  | "luminosity"
  | "multiply"
  | "overlay"
  | "saturation"
  | "screen"
  | "soft-light";

let receivingBytes: any[] = [];
function _savePngCallback(_: any, data: any, length: any) {
  let bytes = (require("ffi") as AnyMod).cast("uint8_t*", data);
  for (let i = 0; i < length; i++) {
    receivingBytes.push(bytes[i]);
  }
  return cairo.enums.CAIRO_STATUS_.success;
}
const savePngCallback = (require("ffi") as AnyMod).cast(
  "cairo_write_func_t",
  _savePngCallback
);

export class CairoRender {
  private surface: cairo.Surface;
  private context: cairo.Context;

  private _width: number;
  private _height: number;
  private _globalCompositeOperation: CompositeOperation;
  private _globalAlpha: number;
  private _fillColor: Color;
  private _strokeColor: Color;
  private _font: string;

  constructor(width: number, height: number) {
    this.surface = cairo.image_surface("argb32", width, height);
    this.context = this.surface.context();

    this._width = width;
    this._height = height;

    this._globalCompositeOperation = "source-over";
    this._globalAlpha = 1.0;
    this._fillColor = Color.transparent;
    this._strokeColor = Color.transparent;
    this._font = "10x sans-serif";
  }

  get ctx() {
    return this.context;
  }

  get width() {
    return this._width;
  }
  set width(value: number) {
    this.setDimensions(value, this._height);
  }

  get height() {
    return this._height;
  }
  set height(value: number) {
    this.setDimensions(this._width, value);
  }

  set color(value: AnyColor) {
    let c = normalizeColor(value)!;
    this.context.rgba(c.red, c.green, c.blue, c.alpha);
  }

  setDimensions(width: number, height: number) {
    const newSurface = cairo.image_surface("argb32", width, height);
    const newContext = newSurface.context();

    this.surface.flush();
    newContext.source(this.surface);
    newContext.paint();

    this.surface = newSurface;
    this.context = newContext;
    this._width = width;
    this._height = height;
  }

  get globalCompositeOperation() {
    return this._globalCompositeOperation;
  }
  set globalCompositeOperation(value: CompositeOperation) {
    this._globalCompositeOperation = value;
  }

  get globalAlpha() {
    return this._globalAlpha;
  }
  set globalAlpha(value: number) {
    this._globalAlpha = value;
  }

  get fillColor() {
    return this._fillColor;
  }
  set fillColor(value: Color) {
    this._fillColor = value;
  }
  private _fill() {
    this.context.rgba(
      this._fillColor.red,
      this._fillColor.green,
      this._fillColor.blue,
      this._fillColor.alpha * this._globalAlpha
    );
    this.context.fill();
  }

  private _fill_preserve() {
    this.context.rgba(
      this._fillColor.red,
      this._fillColor.green,
      this._fillColor.blue,
      this._fillColor.alpha * this._globalAlpha
    );
    this.context.fill_preserve();
  }

  get strokeColor() {
    return this._strokeColor;
  }
  set strokeColor(value: Color) {
    this._strokeColor = value;
  }
  private _stroke() {
    this.context.rgba(
      this._strokeColor.red,
      this._strokeColor.green,
      this._strokeColor.blue,
      this._strokeColor.alpha * this._globalAlpha
    );
    this.context.stroke();
  }

  fill() {
    this._fill();
  }

  fillPreserve() {
    this._fill_preserve();
  }

  stroke() {
    this._stroke();
  }

  paint() {
    this.context.paint();
  }

  rectangle(x: number, y: number, width: number, height: number) {
    this.context.rectangle(x, y, width, height);
  }

  roundedRectangle(
    x: number,
    y: number,
    width: number,
    height: number,
    radius: number
  ) {
    this.context.rounded_rectangle(x, y, width, height, radius);
  }

  clearRectangle(x: number, y: number, width: number, height: number) {
    this.context.save();
    this.context.rectangle(x, y, width, height);
    this.context.clip();
    this.context.rgba(0, 0, 0, 0);
    this.context.operator("source");
    this.context.paint();
    this.context.restore();
  }

  toPngBytes() {
    receivingBytes = [];
    this.surface.save_png(savePngCallback, null);
    debug_(
      "toPngBytes: %s, data: %s",
      receivingBytes.length,
      vim.inspect(receivingBytes)
    );
    return receivingBytes;
  }
}
