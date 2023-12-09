import { debug_, info, warn } from "@core/utils/logger";
import { AnyColor, Color, normalizeColor } from "./widgets/_utils/color";
import * as lgi from "lgi";

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

require("ht.clib.cairo");
(require("ffi") as AnyMod).cdef(`
typedef int32_t cairo_enum_t;
typedef cairo_enum_t cairo_status_t;
typedef cairo_status_t (*cairo_write_func_t) (void *closure, const void *data, unsigned int length);
cairo_status_t
cairo_surface_write_to_png_stream (cairo_surface_t *surface,
                                   cairo_write_func_t write_func,
                                   void *closure);
`);

let receivingBytes: any[] = [];
function _savePngCallback(_: any, data: any, length: any) {
  let bytes = (require("ffi") as AnyMod).cast("uint8_t*", data);
  for (let i = 0; i < length; i++) {
    receivingBytes.push(bytes[i]);
  }
  return 0;
}
const savePngCallback = (require("ffi") as AnyMod).cast(
  "cairo_write_func_t",
  _savePngCallback
);

export class CairoRender {
  private surface: lgi.cairo.Surface;
  private context: lgi.cairo.Context;

  private _width: number;
  private _height: number;
  private _globalCompositeOperation: CompositeOperation;
  private _globalAlpha: number;
  private _fillColor: Color;
  private _strokeColor: Color;
  private _font: string;

  constructor(width: number, height: number) {
    this.surface = lgi.cairo.ImageSurface(0, width, height);
    this.context = lgi.cairo.Context(this.surface);

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
    this.context.set_source_rgba(c.red, c.green, c.blue, c.alpha);
  }

  setDimensions(width: number, height: number) {
    const newSurface = lgi.cairo.ImageSurface(0, width, height);
    const newContext = lgi.cairo.Context(this.surface);

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
    this.context.set_source_rgba(
      this._fillColor.red,
      this._fillColor.green,
      this._fillColor.blue,
      this._fillColor.alpha * this._globalAlpha
    );
    this.context.fill();
  }

  private _fill_preserve() {
    this.context.set_source_rgba(
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
    this.context.set_source_rgba(
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
    this.context.set_source_rgba(0, 0, 0, 0);
    this.context.operator("source");
    this.context.paint();
    this.context.restore();
  }

  toPngBytes() {
    this.surface.flush();

    info("this.surface: %s", tostring(this.surface));

    let _surface_ptr = luaRequire("lgi.core").record.query(
      this.surface,
      "addr"
    );
    const surface_ptr = (require("ffi") as AnyMod).cast(
      "cairo_surface_t*",
      _surface_ptr
    );
    receivingBytes = [];
    try {
      luaRequire("ht.clib.cairo").C.cairo_surface_write_to_png_stream(
        surface_ptr,
        savePngCallback,
        null
      );
    } catch (e) {
      warn("error: %s", e);
    }
    debug_(
      "toPngBytes: %s, data: %s",
      receivingBytes.length,
      vim.inspect(receivingBytes)
    );
    return receivingBytes;
  }

  writePng() {
    this.surface.write_to_png("/tmp/test.png");
  }
}
