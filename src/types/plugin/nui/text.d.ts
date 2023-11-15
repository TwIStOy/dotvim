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
