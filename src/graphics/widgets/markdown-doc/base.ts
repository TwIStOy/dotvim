import { isNil } from "@core/vim";
import { StatelessWidget } from "../stateless-widget";

export abstract class MdNode extends StatelessWidget {
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

  protected findProperty(name: string): string | undefined {
    for (let i = this.props.length - 1; i >= 0; i--) {
      let prop = this.props[i];
      let value = prop.get(name);
      if (!isNil(value)) {
        return value;
      }
    }
  }
}
