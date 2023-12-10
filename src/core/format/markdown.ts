import { info } from "@core/utils/logger";
import { isNil } from "@core/vim";

export interface RenderedNode {
  kind: "unknown" | "span" | "i" | "b";
  content: string | (string | RenderedNode)[];
}

export class MarkupRenderer {
  private source: string;
  private injections: LuaMap<number, { lang: string; root: TSNode }>;
  private parser: LanguageTree;

  constructor(source: string) {
    this.source = source;
    this.injections = new LuaMap();

    this.parser = vim.treesitter.get_string_parser(source, "markdown");
    this.parser.parse(true);

    this.parser.for_each_tree((parent_tree, parent_ltree) => {
      let parent = parent_tree.root();
      for (let [_, child] of parent_ltree.children()) {
        info("child: %s", child);
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

    info("injections: %s", this.injections)
  }

  render() {
    let root = this.parser.parse(true)[0].root();
    return this.renderNode(root, this.parser.lang());
  }

  private skipChildrenHelper(
    node: TSNode,
    lang: string,
    skipStartNum: number,
    skipEndNum: number
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
    let parts: (string | RenderedNode)[] = [];

    for (let i = skipStartNum; i < childNum - skipEndNum; i++) {
      let child = node.child(i);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      let [_childEndRow, _childEndColumn, childEndByte] = child.end_();

      if (startByte < childStartByte) {
        parts.push(this.source.slice(startByte, childStartByte));
      }
      startByte = childEndByte;
      parts.push(this.renderNode(child, lang));
    }
    if (startByte < endByte) {
      parts.push(this.source.slice(startByte, endByte));
    }

    return parts;
  }

  private render_emphasis(node: TSNode, lang: string): RenderedNode {
    return {
      kind: "i",
      content: this.skipChildrenHelper(node, lang, 1, 1),
    };
  }

  private render_strong_emphasis(node: TSNode, lang: string): RenderedNode {
    return {
      kind: "b",
      content: this.skipChildrenHelper(node, lang, 2, 2),
    };
  }

  private renderNode(node: TSNode, lang: string): RenderedNode {
    // try redirect to injection first
    let injection = this.injections.get(node.id());
    if (!isNil(injection)) {
      return this.renderNode(injection.root, injection.lang);
    }

    info("renderNode %s: %s", lang, node.type());

    if (node.type() === "emphasis") {
      return this.render_emphasis(node, lang);
    } else if (node.type() === "strong_emphasis") {
      return this.render_strong_emphasis(node, lang);
    } else {
      // skip this node
      let parts: RenderedNode[] = [];
      for (let [child, _] of node.iter_children()) {
        let res = this.renderNode(child, lang);
        if (res.content.length > 0) {
          parts.push(res);
        }
      }
      return {
        kind: "span",
        content: parts,
      };
    }
  }

  // private visitNode(node: TSNode, lang: string): RenderedNode {
  //   let injection = this.injections.get(node.id());
  //   if (!isNil(injection)) {
  //     this.visitNode(injection.root, injection.lang);
  //   }
  //   let parts = [];
  //   for (let [child, _] of node.iter_children()) {
  //     parts.push(this.renderNode(child, lang));
  //   }
  //   return {
  //     kind: "span",
  //     content: parts,
  //   };
  // }
}
