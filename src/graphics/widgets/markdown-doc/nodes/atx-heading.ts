import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { MdNode } from "../base";
import { MdNodeFactory } from "../node-factory";
import { PangoSpanProperties } from "../property";

export class MdAtxHeading extends MdNode {
  intoWidgetOrSpan(_context: BuildContext): string | Widget {
    let body = this.node.child(1);
    let [_startRow, _startColumn, startByte] = this.node.start();
    let firstChildType;
    {
      let child = this.node.child(0);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      assert(childStartByte === startByte);
      startByte += child.byte_length();
      firstChildType = child.type();
    }
    let [level_str] = string.match(firstChildType, "atx_h(%d+)_marker");
    let level = tonumber(level_str)!;
    let pd = [...this.props];
    let np = new PangoSpanProperties();
    if (level === 1) {
      np.set("font_size", "200%");
    } else if (level === 2) {
      np.set("font_size", "150%");
    } else if (level === 3) {
      np.set("font_size", "120%");
    }
    pd.push(np);
    return MdNodeFactory.getInstance().create(body, this.source, pd);
  }

  override isEmpty(): boolean {
    return false;
  }
}
