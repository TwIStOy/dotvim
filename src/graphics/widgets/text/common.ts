import { AnyColor } from "../_utils";

export interface TextStyle {
  /**
   * @description The color of the text.
   */
  color?: AnyColor;
  /**
   * @description The font family of the text.
   */
  fontFamily?: string;
  /**
   * @description The font weight of the text.
   */
  fontWeight?: string;
  /**
   * @description The font slant of the text.
   */
  fontSlant?: string;
  /**
   * @description The font size of the text.
   */
  fontSize?: number;
  /**
   * @description The underline style of the text.
   */
  underline?: boolean | { color: AnyColor };
  /**
   * @description The underline style of the text.
   */
  background?: AnyColor;
}

/**
 * @description Clip the overflowing text to fix its max width. If placehoder
 * exists, after the text is clipped, a placeholder will be appended to the end
 * of the text.
 */
export interface TextOverflowClip {
  kind: "clip";
  placeholder?: string;
}

export interface TextOverflowWrap {
  kind: "wrap";
  /**
   * How to break lines.
   *
   * - `word`: break lines at word boundaries.
   *   - `hello world` -> `hello` `world`
   *   - `hello-world` -> `hello-` `world`
   *   - `hello_world` -> `hello_` `world`
   * - `char`: break lines at character boundaries.
   * - `tex`: break lines like TeX, and whitespace will be adjusted.
   */
  algorithm?: "word" | "char" | "tex";
}

export type TextOverflowPolicy = TextOverflowClip | TextOverflowWrap;

export function toUtfChars(str: string): string[] {
  let starts = vim.str_utf_pos(str);
  let res = [];
  for (let i = 0; i < starts.length - 1; i++) {
    res.push(str.slice(starts[i] - 1, starts[i + 1] - 1));
  }
  res.push(str.slice(starts[starts.length - 1] - 1));
  return res;
}

let whiteSpaceChars = [
  "\t",
  "\n",
  "\x0b",
  "\x0c",
  "\r",
  " ",
  "\xc2\x85",
  "\xc2\xa0",
  "\xe1\x9a\x80",
  "\xe1\xa0\x8e",
  "\xe2\x80\x80",
  "\xe2\x80\x81",
  "\xe2\x80\x82",
  "\xe2\x80\x83",
  "\xe2\x80\x84",
  "\xe2\x80\x85",
  "\xe2\x80\x86",
  "\xe2\x80\x87",
  "\xe2\x80\x88",
  "\xe2\x80\x89",
  "\xe2\x80\x8a",
  "\xe2\x80\x8b",
  "\xe2\x80\x8c",
  "\xe2\x80\x8d",
  "\xe2\x80\xa8",
  "\xe2\x80\xa9",
  "\xe2\x80\xaf",
  "\xe2\x81\x9f",
  "\xe2\x81\xa0",
  "\xe3\x80\x80",
  "\xef\xbb\xbf",
];

export function isUTFWhitespace(char: string): boolean {
  return whiteSpaceChars.includes(char);
}
