import { StatelessWidget } from "../stateless-widget";

export class MdNodeFactory {
  static _instance?: MdNodeFactory;

  private constructos: Map<
    string,
    (
      node: TSNode,
      source: string,
      inherit: PangoSpanProperties[]
    ) => StatelessWidget
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
    ) => StatelessWidget
  ) {
    this.constructos.set(type, constructor);
  }

  create(
    node: TSNode,
    source: string,
    inherit: PangoSpanProperties[]
  ): StatelessWidget {
    let type = node.type();
    if (this.constructos.has(type)) {
      return this.constructos.get(type)!(node, source, inherit);
    }
    throw new Error(`Unknown node type: ${type}`);
  }
}
