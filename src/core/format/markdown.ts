import { info } from "@core/utils/logger";
import { isNil } from "@core/vim";
import {
  BoldNode,
  CodeBlockNode,
  CodeSpanNode,
  HardLineBreak,
  HeadingNode,
  ItalicNode,
  ListItemNode,
  ParagraphNode,
  RenderedNode,
  SectionNode,
  SpanNode,
  ThematicBreak,
} from "./rendered-node";

export class MarkupRenderer {
  private source: string;
  private injections: LuaMap<number, { lang: string; root: TSNode }>;
  private parser: LanguageTree;

  constructor(source: string) {
    // if the last char is not "\n", append "\n"
    if (source.slice(-1) !== "\n") {
      source += "\n";
    }
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

  render() {
    let root = this.parser.parse(true)[0].root();
    return this.renderNode(root, this.parser.lang(), 0);
  }

  private skipChildrenHelper(
    node: TSNode,
    lang: string,
    depth: number,
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
      let [_childEndRow, _childEndColumn, childEndByte] = child.end_();
      assert(childStartByte === startByte);
      startByte = childEndByte;
    }

    // last children
    for (let i = 0; i < skipEndNum; i++) {
      let child = node.child(node.child_count() - 1 - i);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      let [_childEndRow, _childEndColumn, childEndByte] = child.end_();
      assert(childEndByte === endByte);
      endByte = childStartByte;
    }

    let childNum = node.child_count();
    let parts: (string | RenderedNode)[] = [];

    for (let i = skipStartNum; i < childNum - skipEndNum; i++) {
      let child = node.child(i);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      let [_childEndRow, _childEndColumn, childEndByte] = child.end_();

      if (startByte < childStartByte) {
        // push text part
        parts.push(this.source.slice(startByte, childStartByte));
      }
      startByte = childEndByte;
      // push sub node
      parts.push(this.renderNode(child, lang, depth + 1));
    }
    if (startByte < endByte) {
      let lastContent = this.source.slice(startByte, endByte);
      if (stripTrail) lastContent = lastContent.trimEnd();
      if (lastContent.length > 0) {
        parts.push(lastContent);
      }
    }
    {
      let line = "";
      for (let p of parts) {
        if (line.length > 0) {
          line += ", ";
        }

        if (typeof p === "string") {
          line += vim.inspect(p);
        } else {
          line += p.kind;
        }
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
          if (!p.empty()) {
            break;
          }
        }
        parts.pop();
      }
    }

    return parts;
  }

  private render_emphasis(
    node: TSNode,
    lang: string,
    depth: number
  ): RenderedNode {
    return new ItalicNode(this.skipChildrenHelper(node, lang, depth, 1, 1));
  }

  private render_strong_emphasis(
    node: TSNode,
    lang: string,
    depth: number
  ): RenderedNode {
    return new BoldNode(this.skipChildrenHelper(node, lang, depth, 2, 2));
  }

  private render_atx_heading(
    node: TSNode,
    lang: string,
    depth: number
  ): RenderedNode {
    let [_startRow, _startColumn, startByte] = node.start();
    let [_endRow, _endColumn, _endByte] = node.end_();

    let firstChildType;

    // first children
    {
      let child = node.child(0);
      let [_childStartRow, _childStartColumn, childStartByte] = child.start();
      assert(childStartByte === startByte);
      startByte += child.byte_length();
      firstChildType = child.type();
    }

    // second must be body
    let body = node.child(1);
    let [level] = string.match(firstChildType, "atx_h(%d+)_marker");

    return new HeadingNode(
      this.renderNode(body, lang, depth + 1),
      tonumber(level)!
    );
  }

  private render_fenced_code_block(
    node: TSNode,
    _lang: string,
    _depth: number
  ): RenderedNode {
    let [_startRow, _startColumn, startByte] = node.start();
    let [_endRow, _endColumn, endByte] = node.end_();

    let language = null;

    // first is fenced_code_block_delimiter
    {
      let firstChild = node.child(0);
      if (firstChild.type() === "fenced_code_block_delimiter") {
        let [_childStartRow, _childStartColumn, childStartByte] =
          firstChild.start();
        assert(childStartByte === startByte);
        startByte += firstChild.byte_length();
      }
    }

    // find info_string child
    for (let i = 0; i < node.child_count(); i++) {
      let child = node.child(i);
      if (child.type() === "info_string") {
        language = vim.treesitter.get_node_text(child, this.source);
        let [_childEndRow, _childEndColumn, childEndByte] = child.end_();
        startByte = childEndByte;
        break;
      }
    }

    // last is fenced_code_block_delimiter
    {
      let lastChild = node.child(node.child_count() - 1);
      if (lastChild.type() === "fenced_code_block_delimiter") {
        let [_childStartRow, _childStartColumn, childStartByte] =
          lastChild.start();
        endByte = childStartByte;
      }
    }

    let body = this.source.slice(startByte, endByte);
    return new CodeBlockNode(body, language);
  }

  private render_code_span(
    node: TSNode,
    _lang: string,
    _depth: number
  ): RenderedNode {
    let [_startRow, _startColumn, startByte] = node.start();
    let [_endRow, _endColumn, endByte] = node.end_();

    // first is code_span_delimiter
    {
      let firstChild = node.child(0);
      let [_childStartRow, _childStartColumn, childStartByte] =
        firstChild.start();
      assert(childStartByte === startByte);
      startByte += firstChild.byte_length();
    }

    // last is code_span_delimiter
    {
      let lastChild = node.child(node.child_count() - 1);
      let [_childStartRow, _childStartColumn, childStartByte] =
        lastChild.start();
      endByte = childStartByte;
    }

    let body = this.source.slice(startByte, endByte);
    return new CodeSpanNode(body);
  }

  private render_section(
    node: TSNode,
    lang: string,
    depth: number
  ): RenderedNode {
    return new SectionNode(this.skipChildrenHelper(node, lang, depth, 0, 0));
  }

  private render_thematic_break(
    _node: TSNode,
    _lang: string,
    _depth: number
  ): RenderedNode {
    return new ThematicBreak();
  }

  private render_list_item(node: TSNode, lang: string, depth: number) {
    return new ListItemNode(this.skipChildrenHelper(node, lang, depth, 1, 0));
  }

  private renderNode(node: TSNode, lang: string, depth: number): RenderedNode {
    // try redirect to injection first
    let injection = this.injections.get(node.id());
    if (!isNil(injection)) {
      return this.renderNode(injection.root, injection.lang, depth);
    }

    if (node.type() === "emphasis") {
      return this.render_emphasis(node, lang, depth);
    } else if (node.type() === "strong_emphasis") {
      return this.render_strong_emphasis(node, lang, depth);
    } else if (node.type() === "atx_heading") {
      return this.render_atx_heading(node, lang, depth);
    } else if (node.type() === "fenced_code_block") {
      return this.render_fenced_code_block(node, lang, depth);
    } else if (node.type() === "section") {
      return this.render_section(node, lang, depth);
    } else if (node.type() === "code_span") {
      return this.render_code_span(node, lang, depth);
    } else if (node.type() === "thematic_break") {
      return this.render_thematic_break(node, lang, depth);
    } else if (node.type() === "hard_line_break") {
      return new HardLineBreak();
    } else if (node.type() === "paragraph") {
      return new ParagraphNode(
        this.skipChildrenHelper(node, lang, depth, 0, 0)
      );
    } else if (node.type() === "list") {
      return new ParagraphNode(
        this.skipChildrenHelper(node, lang, depth, 0, 0, true)
      );
    } else if (node.type() === "list_item") {
      return this.render_list_item(node, lang, depth);
    } else {
      // final
      return new SpanNode(this.skipChildrenHelper(node, lang, depth, 0, 0));
    }
  }
}
