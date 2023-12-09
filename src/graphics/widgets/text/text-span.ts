import { ifNil } from "@core/vim";
import { TextStyle, isUTFWhitespace, toUtfChars } from "./common";
import { Color } from "../_utils";
import { InputItem } from "./line-break";
import { BuildContext } from "@glib/build-context";
import { info } from "@core/utils/logger";

interface _TextSpanDataOpt {
  text: string;
  style?: TextStyle;
}

interface _TextSpanGroupDataOpt {
  children: _TextSpan[];
}

export class _TextSpan {
  private _data?: {
    _chars: string[];
    _style: TextStyle;
  };
  private _children?: _TextSpan[];
  private _length: number;

  static defaultStyle: TextStyle = {
    color: Color.from("black"),
    fontFamily: "Sans",
    fontSlant: "normal",
    fontWeight: "normal",
    fontSize: 12,
  };

  constructor(opts: string | _TextSpanDataOpt | _TextSpanGroupDataOpt) {
    if (typeof opts === "string") {
      this._data = {
        _chars: toUtfChars(opts),
        _style: _TextSpan.defaultStyle,
      };
      this._length = this._data._chars.length;
    } else if (opts.hasOwnProperty("text")) {
      opts = opts as _TextSpanDataOpt;
      this._data = {
        _chars: toUtfChars(opts.text),
        _style: ifNil(opts.style, {}),
      };
      this._length = this._data._chars.length;
    } else {
      this._children = (opts as _TextSpanGroupDataOpt).children;
      this._length = this._children.reduce(
        (acc, child) => acc + child.length,
        0
      );
    }
  }

  get length(): number {
    return this._length;
  }

  at(idx: number): [string, TextStyle] | null {
    if (this._data) {
      return [this._data._chars[idx], this._data._style];
    } else if (this._children) {
      let offset = 0;
      for (let child of this._children) {
        if (idx < offset + child.length) {
          return child.at(idx - offset);
        }
        offset += child.length;
      }
    }
    return null;
  }

  setupStyle(context: BuildContext) {
    if (this._data) {
      context.renderer.ctx.font_face(
        ifNil(this._data._style.fontFamily, _TextSpan.defaultStyle.fontFamily),
        ifNil(this._data._style.fontSlant, _TextSpan.defaultStyle.fontSlant),
        ifNil(this._data._style.fontWeight, _TextSpan.defaultStyle.fontWeight)
      );
      context.renderer.ctx.font_size(
        ifNil(this._data._style.fontSize, _TextSpan.defaultStyle.fontSize)
      );
    }
  }

  toInputItems(context: BuildContext): InputItem[] {
    let items: InputItem[] = [];
    if (this._data) {
      this.setupStyle(context);
      for (let char of this._data._chars) {
        if (!isUTFWhitespace(char)) {
          items.push({
            type: "box",
            width: context.renderer.ctx.text_extents(char).x_advance,
            char: char,
            style: this._data._style,
          });
        } else {
          let w = context.renderer.ctx.text_extents(char).x_advance;
          items.push({
            type: "glue",
            width: w,
            style: this._data._style,
            shrink: Math.max(w - 2, 0.5),
            stretch: w * 1.5,
          });
        }
      }
    } else if (this._children) {
      for (let child of this._children) {
        items.push(...child.toInputItems(context));
      }
    }
    return items;
  }
}

export function TextSpan(
  opts: string | _TextSpanDataOpt | _TextSpanGroupDataOpt
): _TextSpan {
  return new _TextSpan(opts);
}
