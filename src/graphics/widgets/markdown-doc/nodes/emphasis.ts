import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { MdNode } from "../base";

export class MdEmphasis extends MdNode {
  intoWidgetOrSpan(context: BuildContext): string | Widget {
    // let res = this.skipChildrenHelper(this.node, 1, 1);
    // let body: string[] = [];
    // for (let i = 0; i < res.length; i++) {
    //   let node = res[i];
    //   if (typeof node === "string") {
    //     body.push(node);
    //   } else {
    //     let data = node.intoWidgetOrSpan(context);
    //     // body.push(node.intoWidget(_context));
    //   }
    // }
    throw new Error("Method not implemented.");
  }

  isEmpty(): boolean {
    // let res = this.skipChildrenHelper(this.node, 1, 1);
    // if (res.length === 0) {
    //   return true;
    // }
    // for (let i = 0; i < res.length; i++) {
    //   let node = res[i];
    //   if (typeof node === "string") {
    //     if (node.trimEnd().length > 0) {
    //       return false;
    //     }
    //   } else {
    //     if (!node.isEmpty()) {
    //       return false;
    //     }
    //   }
    // }
    return true;
  }
}
