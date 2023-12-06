import { Color } from "@glib/color";
import { BuildContext, Widget } from "@glib/widget";

export interface _ContainerBorderOpts {
  /**
   * @description The border radius of the container.
   */
  radius?: number;
  /**
   * @description The border width of the container.
   */
  lineWidth?: number;
  /**
   * @description The border color of the container.
   */
  color?: Color;
}

export interface _ContainerOpts {
  /**
   * @description The height of the container.
   */
  height: number;
  /**
   * @description The width of the container.
   */
  width: number;
  /**
   * @description The border width of the container.
   */
  border?: _ContainerBorderOpts;
  /**
   * @description The background color of the container.
   */
  backgroundColor?: Color;
}

export class _Container extends Widget {
  private _height: number;
  private _width: number;
  private _border?: {
    radius?: number;
    lineWidth?: number;
    color?: Color;
  };
  private _backgroundColor: Color;

  constructor(opts: _ContainerOpts) {
    super();

    this._height = opts.height;
    this._width = opts.width;
    this._border = opts.border;
    this._backgroundColor = opts.backgroundColor ?? Color.fromRGBA(0, 0, 0, 0);
  }

  override canRender() {
    return (
      this._backgroundColor.alpha === 0 && this._border?.color?.alpha === 0
    );
  }

  override build(context: BuildContext) {
    if (!this._border) {
      // simple rectangle
    }
  }
}

export function Container(opts: _ContainerOpts) {
  return new _Container(opts);
}
