declare interface TSNode {
  /**
   * Get the node's immediate parent.
   */
  parent(): TSNode;

  /*
   * Get the node's next sibling.
   */
  next_sibling(): TSNode;

  /*
   * Get the node's previous sibling.
   */
  prev_sibling(): TSNode;

  /*
   * Get the node's next named sibling.
   */
  next_named_sibling(): TSNode;

  /*
   * Get the node's previous named sibling.
   */
  prev_named_sibling(): TSNode;

  /*
   * Iterates over all the direct children of `TSNode`, regardless of whether
   * they are named or not.
   */
  iter_children(): LuaIterable<LuaMultiReturn<[TSNode, string]>>;

  /**
   * Returns a table of nodes corresponding to the `name` field.
   */
  field(name: string): LuaIterable<TSNode>;

  /**
   * Get the node's number of children.
   */
  child_count(): number;

  /**
   * Get the node's child at the given `index`, where zero represents the first
   * child.
   */
  child(index: number): TSNode;

  /**
   * Get the node's number of named children.
   */
  named_child_count(): number;

  /**
   * Get the node's named child at the given `index`, where zero represents the
   * first child.
   */
  named_child(index: number): TSNode;

  /**
   * Get the node's start position. Return three values: the row, column and
   * total byte count (all zero-based).
   */
  start(): LuaMultiReturn<[number, number, number]>;

  /**
   * Get the node's end position.  Return three values: the row, column and
   * total byte count (all zero-based).
   */
  end_(): LuaMultiReturn<[number, number, number]>;

  /**
   * Get the range of the node.
   *
   * Return six values:
   *   - start row
   *   - start column
   *   - start byte
   *   - end row
   *   - end column
   *   - end byte
   */
  range(
    include_bytes: true
  ): LuaMultiReturn<[number, number, number, number, number, number]>;

  /**
   * Get the range of the node.
   *
   * Return fore values:
   *   - start row
   *   - start column
   *   - end row
   *   - end column
   */
  range(
    include_bytes?: false
  ): LuaMultiReturn<[number, number, number, number]>;

  /**
   * Get the node's type as tring.
   */
  type(): string;

  /**
   * Get the node's type as a numerical id.
   */
  symbol(): number;

  /**
   * Check if the node is named. Named nodes correspond to named rules in the
   * grammar, whereas anonymous nodes correspond to string literals in the
   * grammar.
   */
  named(): boolean;

  /**
   * Check if the node is missing. Missing nodes are inserted by the parse in
   * order to recover from certain kinds of syntax errors.
   */
  missing(): boolean;

  /**
   * Check if the node is extra. Extra nodes represent things like comments,
   * which are not required by the grammar but can appear anywhere.
   */
  extra(): boolean;

  /**
   * Check if a syntax node has been edited.
   */
  has_changes(): boolean;

  /**
   * Check if the node is a syntax error or contains any syntax errors.
   */
  has_error(): boolean;

  /**
   * Get an S-expression representing the node as a string.
   */
  sexpr(): string;

  /**
   * Get an unique identifier for the node inside its own tree.
   *
   * No guarantees are made about this identifier's internal representation,
   * except for being a primitive Lua type with value equality (so not a
   * table). Presently it is a (non-printable) string.
   *
   * Note: The `id` is not guaranteed to be unique for nodes from different
   * trees.
   */
  id(): number;

  /**
   * Get the `TSTree` of the node.
   */
  tree(): TSTree;

  /**
   * Check if `rhs` refers to the same node within the same tree.
   */
  equal(rhs: TSNode): boolean;

  named_descendant_for_range(
    start_row: number,
    start_col: number,
    end_row: number,
    end_col: number
  ): TSNode | null;

  /**
   * Returns the number of bytes spanned by the node.
   */
  byte_length(): number;
}

declare interface TSTree {
  /**
   * Return the root node of this tree.
   */
  root(): TSNode;

  /**
   * Returns a copy of `TSTree`.
   */
  copy(): TSTree;
}

declare interface LanguageTree {
  /*
   * Returns a map of language to child tree.
   */
  children(): LuaMap<string, LanguageTree>;

  /**
   * Invalidates this parser and all its children.
   */
  invalidate(reload?: boolean): void;

  /**
   * Returns all trees of the regions parsed by this parser. Does not include
   * child languages. The result is list-like if
   * - this LanguageTree is the root, in which case the result is empty or a singleton list; or
   * - the root LanguageTree is fully parsed.
   */
  trees(): LuaMap<number, TSTree>;

  /**
   * Gets the tree that contains `range`.
   */
  tree_for_range(
    range: [number, number, number, number],
    opts?: {
      /**
       * Ignore injected languages. (default `true`)
       */
      ignore_injections: boolean;
    }
  ): TSTree | null;

  /**
   * Returns the source content of the language tree (bufnr or string).
   */
  source(): number | string;

  /**
   * Recursively parse all regions in the language tree using
   * |treesitter-parsers| for the corresponding languages and run injection
   * queries on the parsed trees to determine whether child trees should be
   * created and parsed.
   *
   * Any region with empty range (`{}`, typically only the root tree) is always
   * parsed; otherwise (typically injections) only if it intersects {range} (or
   * if {range} is `true`).
   *
   * @param range Parse this range in the parser's source. Set to `true` to
   * run a complete parse of the source. Set to `false|nil` to only parse regions
   * with empty ranges.
   */
  parse(range?: boolean): TSTree[];

  /**
   * Gets the language of this tree node.
   */
  lang(): string;

  /**
   * Invokes the callback for each `LanguageTree` recursively.
   *
   * NOTE: This includes the invoking tree's child trees as well.
   */
  for_each_tree(fn: (tree: TSTree, ltree: LanguageTree) => void): void;
}

declare interface TSHighlighter {
  active: LuaMap<number, TSHighlighter>;
  bufnr: number;
}

declare namespace vim {
  export namespace treesitter {
    export const highlighter: TSHighlighter;

    /**
     * @description Returns a string parser.
     *
     * @param str Text to parser.
     * @param lang Language of this string.
     * @param opts Options to pass to the created language tree.
     */
    export function get_string_parser(
      str: string,
      lang: string,
      opts?: LuaTable
    ): LanguageTree;

    export function get_node_text(
      node: TSNode,
      bufnr: number | string,
      opts?: {
        metadata: LuaTable;
      }
    ): string;
  }
}
