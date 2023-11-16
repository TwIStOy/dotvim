interface _NuiTreeNodeBase {
  /**
   * Returns node's id.
   */
  get_id(): string;

  /**
   * Returns node's depth.
   */
  get_depth(): number;

  /**
   * Returns parent node's id.
   */
  get_parent_id(): string;

  /**
   * Checks if node has children.
   */
  has_children(): boolean;

  /**
   * Returns ids of child nodes.
   */
  get_children_ids(): string[];

  /**
   * Checks if node is expanded.
   */
  is_expanded(): boolean;

  /**
   * Expands node.
   */
  expand(): void;

  /**
   * Collapses node.
   */
  collapse(): void;
}

declare type NuiTreeNode<T> = _NuiTreeNodeBase & {
  [K in keyof T]: T[K];
};

// ---@alias nui_tree_get_node_id fun(node: NuiTree.Node): string
declare type NuiTreeGetNodeId<T> = (this: void, node: NuiTreeNode<T>) => string;

// ---@alias nui_tree_prepare_node fun(node: NuiTree.Node, parent_node?: NuiTree.Node): nil | string | string[] | NuiLine | NuiLine[]
declare type NuiTreePrepareNode<T, U> = (
  this: void,
  node: NuiTreeNode<T>,
  parent_node?: NuiTreeNode<U>
) => void | string | string[] | NuiLine | NuiLine[];

/*
---@class nui_tree_internal
---@field buf_options table<string, any>
---@field get_node_id nui_tree_get_node_id
---@field linenr { [1]?: integer, [2]?: integer }
---@field linenr_by_node_id table<string, { [1]: integer, [2]: integer }>
---@field node_id_by_linenr table<integer, string>
---@field prepare_node nui_tree_prepare_node
---@field win_options table<string, any> # deprecated
*/
declare interface NuiTreeInternal<T> {
  buf_options: { [key: string]: any };
  get_node_id: NuiTreeGetNodeId<T>;
  linenr: { [1]?: number; [2]?: number };
  linenr_by_node_id: { [key: string]: { [1]: number; [2]: number } };
  node_id_by_linenr: { [key: number]: string };
  prepare_node: NuiTreePrepareNode<T, any>;
  /// @deprecated
  win_options: { [key: string]: any };
}

/*
---@class nui_tree_options
---@field bufnr integer
---@field ns_id? string|integer
---@field nodes? NuiTree.Node[]
---@field get_node_id? fun(node: NuiTree.Node): string
---@field prepare_node? fun(node: NuiTree.Node, parent_node?: NuiTree.Node): nil|string|string[]|NuiLine|NuiLine[]
*/
declare interface NuiTreeOptions<T> {
  /**
   *Id of the buffer where the tree will be rendered.
   */
  bufnr: number;

  /**
   * Namespace id (number) or name (string).
   */
  ns_id?: number | string;

  nodes: NuiTreeNode<T>[];

  /**
   * If provided, this function is used for generating node's id.
   *
   * The return value should be a unique string.
   */
  get_node_id?(node: NuiTreeNode<T>): string;

  /**
   * If provided, this function is used for preparing each node line.
   *
   * The return value should be a NuiLine object or string or a list containing either of them.
   *
   * If return value is nil, that node will not be rendered.
   */
  prepare_node?(
    node: NuiTreeNode<T>,
    parent_node?: NuiTreeNode<any>
  ): void | string | string[] | NuiLine | NuiLine[];

  /**
   * Contains all buffer related options (check :h options | /local to buffer).
   */
  buf_options?: {
    [key: string]: any;
  };
}

/*
---@class NuiTree
---@field bufnr integer
---@field nodes { by_id: table<string,NuiTree.Node>, root_ids: string[] }
---@field ns_id integer
---@field private _ nui_tree_internal
---@field winid number # @deprecated
*/

/**
 * NuiTree can render tree-like structured content on the buffer.
 */
declare interface NuiTree<Ctx> {
  get_node<T extends number | string>(
    node_id_or_linenr?: T
  ):
    | LuaMultiReturn<
        [
          T extends string
            ? NuiTreeNode<Ctx>
            : T extends number
            ? NuiTreeNode<Ctx> | null
            : NuiTreeNode<Ctx>,
          number,
          number,
        ]
      >
    | LuaMultiReturn<[null, null, null]>;

  /**
   * If parent_id is present, child nodes under that parent are returned,
   * Otherwise root nodes are returned.
   */
  get_nodes(parent_id?: string): NuiTreeNode<Ctx>[];

  /**
   * Adds a node to the tree.
   */
  add_node(node: NuiTreeNode<Ctx>, parent_id?: string): void;

  /**
   * Removes a node from the tree.
   */
  remove_node(node_id: string): NuiTreeNode<Ctx> | null;

  /**
   * Adds a node to the tree.
   */
  set_nodes(node: NuiTreeNode<Ctx>, parent_id?: string): void;

  /**
   * Renders the tree on buffer.
   *
   * @param linenr_start start line number (1-indexed)
   */
  render(linenr_start?: number): void;

  bufnr: number;

  nodes: {
    by_id: LuaTable<string, NuiTreeNode<Ctx>>;
    root_ids: string[];
  };

  ns_id: number;

  _: NuiTreeInternal<Ctx>;

  /// @deprecated
  winid: number;
}
