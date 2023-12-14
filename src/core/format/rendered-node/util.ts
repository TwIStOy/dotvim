import * as lgi from "lgi";

export function escapeMarkup(str: string): string {
  return lgi.GLib.markup_escape_text(str, -1);
}

export function packPropertiesTbl(tbl: LuaTable<any, any>): string {
  let ret = [];
  for (let [k, v] of tbl) {
    ret.push(`${k}="${v}"`);
  }
  return ret.join(" ");
}
