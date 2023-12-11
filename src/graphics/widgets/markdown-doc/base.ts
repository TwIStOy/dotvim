import { isNil } from "@core/vim";
import { PangoSpanProperties } from "./property";
import { Widget } from "@glib/widget";
import { BuildContext } from "@glib/build-context";
import { Markup } from "../markup";
import { MdEmptibleNode, MdNodeFactory } from "./node-factory";

export abstract class MdNode extends MdEmptibleNode {
  protected source: string;
  protected node: TSNode;
  protected props: PangoSpanProperties[];

  constructor(node: TSNode, source: string, inherit: PangoSpanProperties[]) {
    super({
      flexible: "none",
      flexPolicy: "shrink",
    });

    this.source = source;
    this.node = node;
    this.props = [...inherit];
  }

  abstract intoWidgetOrSpan(context: BuildContext): Widget | string;

  override intoWidget(context: BuildContext): Widget {
    let w = this.intoWidgetOrSpan(context);
    if (typeof w === "string") {
      return Markup(w);
    } else {
      return w;
    }
  }

  protected findProperty(name: string): string | undefined {
    for (let i = this.props.length - 1; i >= 0; i--) {
      let prop = this.props[i];
      let value = prop.get(name);
      if (!isNil(value)) {
        return value;
      }
    }
  }

  protected packProperties(): string {
    let props: LuaTable = vim.tbl_extend(
      "force",
      ...this.props.map((p) => p.properties)
    );
    let p = [];
    for (let [k, v] of props) {
      p.push(`${k}="${v}"`);
    }
    return p.join(" ");
  }

  protected skipChildrenHelper(
    node: TSNode,
    _lang: string,
    _depth: number,
    skipStartNum: number,
    skipEndNum: number,
    stripTrail: boolean = true
  ) {
    let [_startRow, _startColumn, startByte] = node.start();
    let [_endRow, _endColumn, endByte] = node.end_();

    // first children
    for (let i = 0; i < skipStartNum; i++) {
      let child = node.child(i);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      assert(childStartByte === startByte);
      startByte += child.byte_length();
    }

    // last children
    for (let i = 0; i < skipEndNum; i++) {
      let child = node.child(node.child_count() - 1 - i);
      let [_childEndRow, _childEndColumn, childEndByte] = child.end_();
      assert(childEndByte === endByte);
      endByte -= child.byte_length();
    }

    let childNum = node.child_count();
    let parts: (string | MdEmptibleNode)[] = [];

    for (let i = skipStartNum; i < childNum - skipEndNum; i++) {
      let child = node.child(i);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      let [_childEndRow, _childEndColumn, childEndByte] = child.end_();

      if (startByte < childStartByte) {
        parts.push(this.source.slice(startByte, childStartByte));
      }
      startByte = childEndByte;
      parts.push(
        MdNodeFactory.getInstance().create(child, this.source, this.props)
      );
    }
    if (startByte < endByte) {
      let lastContent = this.source.slice(startByte, endByte);
      if (stripTrail) lastContent = lastContent.trimEnd();
      if (lastContent.length > 0) {
        parts.push(lastContent);
      }
    }
    if (stripTrail) {
      while (parts.length > 0) {
        let p = parts[parts.length - 1];
        if (typeof p === "string") {
          let newP = p.trimEnd();
          if (newP.length > 0) {
            break;
          }
        } else {
          if (!p.isEmpty()) {
            break;
          }
        }
        parts.pop();
      }
    }

    return parts;
  }
}
