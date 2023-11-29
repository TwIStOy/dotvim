declare namespace LuaSnip {
  export interface NodeOpts {
    node_ext_opts?: LuaTable;
    parent_ext_opts?: LuaTable;
    key?: any;
  }

  export interface Node {}

  export interface TextNode extends Node {}

  export function t(text: string | string[], opts?: NodeOpts): TextNode;

  export interface InsertNode extends Node {}

  export function i(
    jump_index: number,
    text: string | string[],
    opts?: NodeOpts
  ): InsertNode;

  export interface FunctionNode extends Node {}

  export function f<UA extends any[]>(
    fn: (
      argnode_text: string[][],
      parent: Node,
      ...args: UA
    ) => string | string[],
    argnode_references: number[],
    opts?: NodeOpts & {
      user_args?: UA;
    }
  ): FunctionNode;

  export interface ChoiceNode extends Node {}

  export function c(
    jump_index: number,
    choices: Node[] | Node,
    opts?: NodeOpts & {
      restore_cursor?: boolean;
    }
  ): ChoiceNode;

  export interface SnippetNode extends Node {}

  export function sn(
    jump_index: number,
    nodes: Node[] | Node,
    opts?: NodeOpts & {
      callbacks?: LuaTable;
      child_ext_opts?: LuaTable;
      merge_child_ext_opts?: LuaTable;
    }
  ): SnippetNode;

  export interface IndentSnippetNode extends Node {}

  export function isn(
    jump_index: number,
    nodes: Node[] | Node,
    indentstring: string,
    opts?: NodeOpts & {
      callbacks?: LuaTable;
      child_ext_opts?: LuaTable;
      merge_child_ext_opts?: LuaTable;
    }
  ): IndentSnippetNode;

  export interface DynamicNode extends Node {}
}
