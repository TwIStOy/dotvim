declare namespace LuaSnip {
  export interface ExpandParams {
    /**
     * The fully matched trigger.
     */
    trigger?: string;
    /**
     * This list could update the capture-groups from parameter in snippet expansion.
     */
    captures?: LuaTable;
    /**
     * Both (0, 0)-indexed, the region where text has to be cleared before inserting the snippet.
     */
    clear_region?: {
      from: [number, number];
      to: [number, number];
    };
    /**
     * Override or extend the snippet's environment
     */
    env_override?: {
      [key: string]: string | string[];
    };
  }

  export interface Snippet {}

  export interface SnippetContext {
    trig: string;
    name?: string;
    /// Same as `dscr`.
    desc?: string;
    /// Description of the snippet, \n-separated or table for multiple lines.
    dscr?: string;
    /// The snippet is only expanded if the word (`[%w_]+`) before the cursor
    /// matches the trigger entirely. True by default.
    wordTrig?: boolean;
    /**
     * Whether the trigger should be interpreted as a lua pattern.
     * False by default.
     * Consider setting trigEngine to "pattern" instead, it is more expressive,
     * and in line with other settings.
     */
    regTrig?: boolean;
    /// Determines how `trig` is interpreted.
    trigEngine?:
      | "plain" // The default-behaviour, the trigger has to match the text
      // before the cursor exactly.
      | "pattern" // The trigger is interpreted as a lua pattern.
      | "ecma" // The trigger is interpreted as a ECMAScript RegExp.
      | "vim" // The trigger is interpreted as a vim regex.
      | ((
          trig: string
        ) => (
          line_to_cursor: string,
          trigger: string
        ) => LuaMultiReturn<[string, string[]]>);
    /**
     * Textual representation of the snippet, specified like desc.
     */
    docstring?: string;
    /**
     * Hint for completion engines.
     */
    hidden?: boolean;
    /**
     * Priority of the snippet, 1000 by default.
     */
    priority?: number;
    /**
     * Whether this snippet has to be triggered by ls.expand() or whether is
     * triggered automatically.
     */
    snippetType?: "snippet" | "autosnippet";
    /**
     * This function will be evaluated in `Snippet:matches()` to decide
     * whether the snippet can be expanded or not.
     */
    resolveExpandParams?: (
      /**
       * The expanding snippet.
       */
      snippet: Snippet,
      /**
       * The line up to cursor.
       */
      line_to_cursor: string,
      /**
       * The fully matched trigger.
       */
      matched_trigger: string,
      /**
       * `captures` as returned by the `trigEngine`.
       */
      captures: LuaTable
    ) => LuaSnip.ExpandParams | null;
    /**
     * Whether the snippet can be expanded.
     */
    condition?: (
      line_to_cursor: string,
      matched_trigger: string,
      captures: LuaTable
    ) => boolean;
    shown_condition?: (line_to_cursor: string) => boolean;
    /**
     * A single node or a list of nodes. The nodes that make up the snippet.
     */
    nodes: Node | Node[];
    opts?: {
      /**
       * Contains functions that are called upon entering/leaving a node of
       * this snippet.
       */
      callbacks?: LuaTable;
      child_ext_opts?: LuaTable;
      merge_child_ext_opts?: LuaTable;
    };
  }
}
