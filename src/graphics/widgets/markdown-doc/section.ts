import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { MdNode } from "./base";
import { Column } from "../column";
import { MdNodeFactory } from "./node-factory";

export class MdSection extends MdNode {
  intoWidget(_context: BuildContext): Widget {
    let cnt = this.node.child_count();
    let items = [];
    let factory = MdNodeFactory.getInstance();
    for (let i = 0; i < cnt; i++) {
      let child = this.node.child(i);
      items.push(factory.create(child, this.source, this.props));
    }
    return Column({
      children: items,
    });
  }
}
