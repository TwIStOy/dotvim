import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { MdNode } from "./base";
import { Container } from "../container";
import { Padding, normalizeColor } from "../_utils";
import { ifNil } from "@core/vim";

export class MdThematicBreak extends MdNode {
  intoWidget(_context: BuildContext): Widget {
    let fg = this.findProperty("foreground");
    return Container({
      margin: Padding.vertical(4),
      height: 2,
      width: "expand",
      color: normalizeColor(ifNil(fg, "black") as any),
    });
  }
}
