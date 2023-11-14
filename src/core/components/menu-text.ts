import { NuiLine, NuiText } from "../../extra/nui";
import { Cache } from "../cache";
import { uniqueArray } from "../utils/array";

interface MenuTextPart {
  text: string;
  kind: "normal" | "key";
}

const _text_caches = new Cache();

/**
 * A menu text component.
 */
export class MenuText {
  private _raw_text: string;
  private _parts: MenuTextPart[];
  private _keys: string[];

  constructor(text: string) {
    this._raw_text = text;

    if (this._raw_text === "---") {
      this._parts = [];
      this._keys = [];
      return;
    }

    // parse "abc" -> parts: ["abc"]
    // parse "ab&c" -> parts: ["ab", "c"], keys: ["c"]
    // parse "ab&cbcd&d" -> parts: ["ab", "c", "bcd", "d"], keys: ["c", "d"]

    let parts: MenuTextPart[] = [];
    let keys = [];

    let next_is_key = false;
    let last_part: string = "";
    for (let i = 0; i < this._raw_text.length; i++) {
      const c = this._raw_text[i];
      if (next_is_key) {
        keys.push(c);
        if (last_part.length > 0) {
          parts.push({ text: last_part, kind: "normal" });
        }

        last_part = "";
        parts.push({ text: c, kind: "key" });
        next_is_key = false;
      } else {
        if (c === "&") {
          next_is_key = true;
        } else {
          last_part += c;
        }
      }
    }
    if (last_part.length > 0) {
      parts.push({ text: last_part, kind: "normal" });
    }

    this._parts = parts;
    this._keys = uniqueArray(keys);
  }

  /**
   * Returns the text of this menu text.
   */
  get text(): string {
    return _text_caches.ensure(this._raw_text, () => {
      return this._parts.map((part) => part.text).join("");
    });
  }

  /**
   * Returns trigger keys parsed from this menu text.
   */
  get keys(): string[] {
    return this._keys;
  }

  get length(): number {
    return this.text.length;
  }

  isSeparator(): boolean {
    return this._raw_text === "---";
  }

  asNuiText(): NuiText[] {
    let res: NuiText[] = [];

    for (const part of this._parts) {
      if (part.kind === "key") {
        res.push(NuiText(part.text, "@variable.builtin"));
      } else {
        res.push(NuiText(part.text));
      }
    }

    return res;
  }

  asNuiLine(): NuiLine {
    return NuiLine(this.asNuiText());
  }
}
