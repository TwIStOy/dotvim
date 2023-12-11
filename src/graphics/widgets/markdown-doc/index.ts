import { BuildContext } from "@glib/build-context";
import { Widget } from "@glib/widget";
import { StatelessWidget } from "../stateless-widget";

export class MarkdownDocument extends StatelessWidget {
  private source: string;
  private injections: LuaMap<number, { lang: string; root: TSNode }>;
  private parser: LanguageTree;

  constructor(source: string) {
    super({
      flexible: "none",
      flexPolicy: "shrink",
    });

    this.source = source;
    this.injections = new LuaMap();

    this.parser = vim.treesitter.get_string_parser(source, "markdown");
    this.parser.parse(true);

    this.parser.for_each_tree((parent_tree, parent_ltree) => {
      let parent = parent_tree.root();
      for (let [_, child] of parent_ltree.children()) {
        for (let [_, tree] of child.trees()) {
          let r = tree.root();
          let [startLine, startCol, endLine, endCol] = r.range(false);
          let node = assert(
            parent.named_descendant_for_range(
              startLine,
              startCol,
              endLine,
              endCol
            )
          );
          let id = node.id();
          if (
            !this.injections.has(id) ||
            r.byte_length() > this.injections.get(id)!.root.byte_length()
          ) {
            this.injections.set(id, {
              lang: child.lang(),
              root: r,
            });
          }
        }
      }
    });
  }

  intoWidget(context: BuildContext): Widget {
    throw new Error("Method not implemented.");
  }
}
