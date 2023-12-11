import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { ifNil } from "@core/vim";
import { MdNode } from "../base";
import { Container } from "@glib/widgets/container";
import { Padding, normalizeColor } from "@glib/widgets/_utils";

export class MdThematicBreak extends MdNode {
  intoWidgetOrSpan(_context: BuildContext): Widget {
    let fg = this.findProperty("foreground");
    return Container({
      margin: Padding.vertical(4),
      height: 2,
      width: "expand",
      color: normalizeColor(ifNil(fg, "black") as any),
    });
  }

  override isEmpty(): boolean {
    return false;
  }
}
