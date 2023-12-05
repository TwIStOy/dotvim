import * as cairo from "3rd.cairo.cairo";

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

export class Context2DRender {
  private surface: cairo.Surface;
  private context: cairo.Context;

  private _width: number;
  private _height: number;
  private _globalCompositeOperation: CompositeOperation;
  private _globalAlpha: number;
  // private _fillColor: Color;
  // private _strokeColor: Color;
  private _font: string;

  constructor(width: number, height: number) {
    this.surface = cairo.image_surface("argb32", width, height);
    this.context = this.surface.context();

    this._width = width;
    this._height = height;

    this._globalCompositeOperation = "source-over";
    this._globalAlpha = 1.0;
    // this._fillColor = new Color(0x000000);
    // this._strokeColor = new Color(0x000000);
    this._font = "10x sans-serif";
  }

  function setDimensions(width: number, height: number) {
    this.surface = cairo.image_surface("argb32", width, height);
    this.context = this.surface.context();

    this._width = width;
    this._height = height;
  }
}
