import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { MdNode } from "../base";
import { MdNodeFactory } from "../node-factory";
import { Column } from "@glib/widgets/column";

export class MdSection extends MdNode {
  intoWidgetOrSpan(_context: BuildContext): Widget {
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

  override isEmpty(): boolean {
    let cnt = this.node.child_count();
    let items = [];
    let factory = MdNodeFactory.getInstance();
    for (let i = 0; i < cnt; i++) {
      let child = this.node.child(i);
      items.push(factory.create(child, this.source, this.props));
    }
    return !items.some((i) => !i.isEmpty());
  }
}
