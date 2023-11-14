interface TextExtmarkOptions {
  id?: number;
  hl_group?: string;
  end_col?: number;
}

declare interface NuiText {
  set(content: string, extmark?: string | TextExtmarkOptions): this;

  content(): string;

  extmark(): TextExtmarkOptions;

  width(): number;

  length(): number;

  /**
   * @param bufnr The buffer number
   * @param ns_id The namespace id
   * @param linenr The line number, 1-indexed
   * @param byte_start start position of the text on the line, 0-indexed
   */
  highlight(
    bufnr: number,
    ns_id: number,
    linenr: number,
    byte_start: number
  ): void;

  /**
   * Sets the text on buffer and applies highlight.
   *
   * @param bufnr The buffer number
   * @param ns_id The namespace id
   * @param linenr_start The line number, 1-indexed
   * @param byte_start The byte start, 0-indexed
   * @param linenr_end The line number, 1-indexed
   * @param byte_end end position of the text on the line, 0-indexed
   */
  render(
    bufnr: number,
    ns_id: number,
    linenr_start: number,
    byte_start: number,
    linenr_end?: number,
    byte_end?: number
  ): void;

  /*
   * Sets the text on buffer and applies highlight.
   * This does the thing as text:render method, but you can use character
   * count instead of byte count. It will convert multibyte character count to
   * appropriate byte count for you.
   *
   * @param bufnr The buffer number
   * @param ns_id The namespace id
   * @param linenr_start The line number, 1-indexed
   * @param char_start The character start, 0-indexed
   * @param linenr_end The line number, 1-indexed
   * @param char_end end position of the text on the line, 0-indexed
   */
  render_char(
    bufnr: number,
    ns_id: number,
    linenr_start: number,
    char_start: number,
    linenr_end?: number,
    char_end?: number
  ): void;
}

declare interface NuiLine {
  /**
   * Adds a chunk of content to the line.
   *
   * @param text The content to add.
   * @param highlight The highlight group to use for the text.
   */
  append<T extends string | NuiText | NuiLine>(
    text: T,
    highlight?: string | {}
  ): T extends NuiLine ? NuiLine : NuiText;

  /**
   * Returns the line content.
   */
  content(): string;

  /**
   * Applies highlight for the line
   * @param bufnr The buffer number
   * @param ns_id The namespace id, use `-1` for fallback namespace
   * @param linenr The line number, 1-indexed
   */
  highlight(bufnr: number, ns_id: number, linenr: number): void;

  /**
   * Sets the line content on buffer and applies highlight.
   *
   * @param bufnr The buffer number
   * @param ns_id The namespace id, use `-1` for fallback namespace
   * @param linenr The line number, 1-indexed
   * @param linenr_end The line number, 1-indexed
   */
  render(
    bufnr: number,
    ns_id: number,
    linenr_start: number,
    linenr_end?: number
  ): void;
}

/**
 * Border related options.
 */
declare interface NuiBorderOpts {
  padding?:
    | [number, number] // [vertical, horizontal]
    | {
        top?: number;
        right?: number;
        bottom?: number;
        left?: number;
      };

  style?:
    | "single"
    | "double"
    | "rounded"
    | "solid"
    | "shadow"
    | "none"
    | {
        top_left: string;
        top_right: string;
        bottom_left: string;
        bottom_right: string;
        top: string;
        bottom: string;
        left: string;
        right: string;
      }
    | (string | [string, string] | NuiText)[];

  text?: {
    top: string | NuiLine | NuiText | [string, string];
    top_align?: "left" | "center" | "right"; // top border text alignment, default "center"
    bottom: string | NuiLine | NuiText | [string, string];
    bottom_align?: "left" | "center" | "right"; // bottom border text alignment, default "center"
  };
}

declare interface NuiPopupOptions {
  border?: NuiBorderOpts;

  /*
   * Namespace id (number) or name (string).
   */
  ns_id?: number | string;

  /**
   * Decides which corner of the popup to place at position.
   */
  anchor?: "NW" | "NE" | "SW" | "SE";

  /**
   * This option affects how position and size are calculated.
   *
   * Default is `"win"`.
   */
  relative?:
    | "editor"
    | "win"
    | "cursor"
    | "mouse"
    | {
        type: "editor" | "win" | "cursor" | "mouse";
        winid?: number;
        position?: {
          row?: number;
          col?: number;
        };
      };

  /**
   * Position is calculated from the top-left corner.
   *
   * If position is number or percentage string, it applies to both row and col. Or you can pass a table to set them separately.
   * For percentage string, position is calculated according to the option relative. If relative is set to "buf" or "cursor", percentage string is not allowed.
   */
  position?:
    | number
    | string
    | {
        row?: number | string;
        col?: number | string;
      };

  /*
   * Determines the size of the popup.
   *
   * If size is number or percentage string, it applies to both width and height. You can also pass a table to set them separately.
   *
   * For percentage string, size is calculated according to the option relative. If relative is set to "buf" or "cursor", window size is considered.
   */
  size?:
    | number
    | string
    | {
        width?: number | string;
        height?: number | string;
      };

  /**
   * If true, the popup is entered immediately after mount.
   */
  enter?: boolean;

  /*
   * If false, the popup can not be entered by user actions (wincmds, mouse events).
   */
  focusable?: boolean;

  /**
   * Sets the order of the popup on z-axis.
   * Popup with higher the zindex goes on top of popups with lower zindex.
   */
  zindex?: number;

  /**
   * Contains all buffer related options (check :h options | /local to buffer).
   */
  buf_options?: {};

  /**
   * Contains all window related options (check :h options | /local to window).
   */
  win_options?: {};

  /**
   * You can pass bufnr of an existing buffer to display it on the popup.
   */
  bufnr?: number;
}

declare interface NuiPopup {
  /**
   * Mounts the popup.
   */
  mount(): void;

  /**
   * Unmounts the popup.
   */
  unmount(): void;

  /**
   * Hides the popup window. Preserves the buffer (related content, autocmds and keymaps).
   */
  hide(): void;

  /**
   * Shows the popup window.
   */
  show(): void;

  /**
   * Sets keymap for the popup.
   */
  map(
    mode: string,
    lhs: string,
    handler: string | (() => void),
    opts?: {} // TODO(hawtian): fix keymap options
  ): void;

  /**
   * Unsets keymap for the popup.
   */
  unmap(mode: string, lhs: string): void;

  /**
   * Sets autocmd for the popup.
   */
  on(
    event: string | string[],
    handler: () => void,
    opts?: {
      once?: boolean;
      nested?: boolean;
    }
  ): void;

  /**
   * Unsets autocmd for the popup.
   */
  off(event: string | string[]): void;

  /**
   * Sets the layout of the popup. You can use this method to change popup's size or position after it's mounted.
   */
  update_layout(
    opts: Pick<NuiPopupOptions, "anchor" | "relative" | "position" | "size">
  ): void;

  border: {
    /**
     * Sets the border's highlight.
     */
    set_highlight(hl_group: string): void;

    /**
     * Sets the border's style.
     */
    set_style(style: NuiBorderOpts["style"]): void;

    /**
     * Sets the border's text.
     */
    set_text(
      edge: "top" | "bottom" | "left" | "right",
      text: string,
      align: "left" | "right" | "center"
    ): void;
  };
}

declare interface NuiInputOptions {
  /**
   * Prefix in the input.
   */
  prompt?: string | NuiText;

  /**
   * Default value placed in the input on mount
   */
  default_value?: string;

  on_close?: () => void;

  on_submit?: (value: string) => void;

  on_change?: (value: string) => void;

  disable_cursor_position_patch?: boolean;
}

declare interface NuiInput extends NuiPopup {}

declare interface NuiMenuOptions {
  lines: NuiMenuItem[];

  prepare_item?: (item: NuiMenuItem) => string[] | NuiLine[];

  should_skip_item?: (item: NuiMenuItem) => boolean;

  /**
   * Maximum height of the menu.
   */
  max_height?: number;

  /**
   * Minimum height of the menu.
   */
  min_height?: number;

  /**
   * Maximum width of the menu.
   */
  max_width?: number;

  /**
   * Minimum width of the menu.
   */
  min_width?: number;

  keymap: {
    close: string | string[];
    focus_next: string | string[];
    focus_prev: string | string[];
    submit: string | string[];
  };

  /**
   * Callback function, called when menu item is focused.
   */
  on_change?: (item: NuiMenuItem, menu: NuiMenu) => void;

  /**
   * Callback function, called when menu is closed.
   */
  on_close?: () => void;

  /**
   * Callback function, called when menu is submitted.
   */
  on_submit?: (item: NuiMenuItem) => void;
}

declare interface NuiMenuItem extends NuiTreeNode {}

declare interface NuiMenu extends NuiPopup {
  tree: NuiTree;
}

declare interface NuiTreeOptions {
  /**
   *Id of the buffer where the tree will be rendered.
   */
  bufnr: number;

  /**
   * Namespace id (number) or name (string).
   */
  ns_id?: number | string;

  nodes: NuiTreeNode[];

  /**
   * If provided, this function is used for generating node's id.
   *
   * The return value should be a unique string.
   */
  get_node_id?(node: NuiTreeNode): string;

  /**
   * If provided, this function is used for preparing each node line.
   *
   * The return value should be a NuiLine object or string or a list containing either of them.
   *
   * If return value is nil, that node will not be rendered.
   */
  prepare_node?(
    node: NuiTreeNode,
    parent_node?: NuiTreeNode
  ): void | string | string[] | NuiLine | NuiLine[];

  /**
   * Contains all buffer related options (check :h options | /local to buffer).
   */
  buf_options?: {
    [key: string]: any;
  };
}

declare interface NuiTreeNodeBase {
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

declare type NuiTreeNode<T = {}> = NuiTreeNodeBase & T;

/**
 * NuiTree can render tree-like structured content on the buffer.
 */
declare interface NuiTree {
  get_node<T extends number | string | undefined>(
    node_id_or_linenr: T
  ): LuaMultiReturn<
    [
      T extends string
        ? NuiTreeNode | null
        : T extends number
        ? NuiTreeNode | null
        : NuiTreeNode | null,
      number | null,
      number | null,
    ]
  >;

  /**
   * If parent_id is present, child nodes under that parent are returned,
   * Otherwise root nodes are returned.
   */
  get_nodes(parent_id?: string): NuiTreeNode[];

  /**
   * Adds a node to the tree.
   */
  add_node(node: NuiTreeNode, parent_id?: string): void;

  /**
   * Removes a node from the tree.
   */
  remove_node(node_id: string): NuiTreeNode | null;

  /**
   * Adds a node to the tree.
   */
  set_nodes(node: NuiTreeNode, parent_id?: string): void;

  /**
   * Renders the tree on buffer.
   *
   * @param linenr_start start line number (1-indexed)
   */
  render(linenr_start?: number): void;

  bufnr: number;

  nodes: {
    by_id: LuaTable<string, NuiTreeNode>;
    root_ids: string[];
  };

  ns_id: number;
}
