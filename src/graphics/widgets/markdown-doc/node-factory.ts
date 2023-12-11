import { BuildContext } from "@glib/build-context";
import { StatelessWidget } from "../stateless-widget";
import { PangoSpanProperties } from "./property";
import { Widget } from "@glib/widget";

export class MdNodeFactory {
  static _instance?: MdNodeFactory;

  private constructos: Map<
    string,
    (
      node: TSNode,
      source: string,
      inherit: PangoSpanProperties[]
    ) => MdEmptibleNode
  > = new Map();

  static getInstance() {
    if (!MdNodeFactory._instance) {
      MdNodeFactory._instance = new MdNodeFactory();
    }
    return MdNodeFactory._instance;
  }

  register(
    type: string,
    constructor: (
      node: TSNode,
      source: string,
      inherit: PangoSpanProperties[]
    ) => MdEmptibleNode
  ) {
    this.constructos.set(type, constructor);
  }

  create(
    node: TSNode,
    source: string,
    inherit: PangoSpanProperties[]
  ): MdEmptibleNode {
    let type = node.type();
    if (this.constructos.has(type)) {
      return this.constructos.get(type)!(node, source, inherit);
    }
    throw new Error(`Unknown node type: ${type}`);
  }
}

export abstract class MdEmptibleNode extends StatelessWidget {
  abstract isEmpty(): boolean;

  abstract intoWidgetOrSpan(context: BuildContext): Widget | string;
}
