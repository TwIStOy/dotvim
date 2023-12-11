import * as lgi from "lgi";

export function escapeMarkup(str: string): string {
  return lgi.GLib.markup_escape_text(str, -1);
}
