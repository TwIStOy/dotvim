/** @noSelfInFile **/

export interface CursorPosition {
  row: number;
  col: number;
}

/**
 * @brief Get the cursor position in the current window.
 * @param winnr number?
 * @returns CursorPosition Both indexes are 0-based.
 */
export function getCursor0Index(winnr?: number): CursorPosition {
  winnr = winnr || 0;
  let c = vim.api.nvim_win_get_cursor(winnr);
  c[0] = c[0] - 1;
  return {
    row: c[0],
    col: c[1],
  };
}

/**
 * @brief Check if a value is nil or vim.NIL.
 */
export function isNil(v: any): boolean {
  return v === undefined || v === null || v === vim.NIL;
}

/**
 * @brief Return the first non-nil value.
 */
export function ifNil(...args: any[]): any {
  for (let i = 0; i < args.length; i++) {
    if (!isNil(args[i])) {
      return args[i];
    }
  }
  return null;
}

export function normalizeColorValue(v: number | string): string {
  if (typeof v === "number") {
    return `#${v.toString(16)}`;
  }
  return v;
}

export function normalizeStrList(v?: string | string[]): string[] {
  if (!v) {
    return [];
  }
  if (typeof v === "string") {
    return [v];
  }
  return v;
}

export class VimBuffer {
  bufnr: number;
  filetype: string;
  fullFileName: string;
  lspServers: vim.lsp.client[] = [];
  tsHighlighter: any[];

  constructor(bufnr: number) {
    this.bufnr = bufnr;
    this.filetype = vim.api.nvim_get_option_value("filetype", {
      buf: bufnr,
    }) as string;
    this.fullFileName = vim.api.nvim_buf_get_name(bufnr);
    this.lspServers = vim.lsp.get_clients({
      bufnr: bufnr,
    });
    this.tsHighlighter = [vim.treesitter.highlighter.active.get(bufnr)];
  }

  asCacheKey(): string {
    let parts = [
      this.filetype,
      this.fullFileName,
      this.lspServers.length,
      this.tsHighlighter.length,
    ];
    for (let server of this.lspServers) {
      parts.push(server.name);
    }
    return vim.json.encode(parts);
  }

  numberOfLspAttached(): number {
    return this.lspServers.filter((server) => {
      return server.name !== "null-ls" && server.name != "copilot";
    }).length;
  }
}

export function closePreviewWindow(winnr: number, bufnrs: number[]) {
  const fn = () => {
    if (bufnrs.includes(vim.api.nvim_get_current_buf())) {
      return;
    }
    pcall(vim.api.nvim_del_augroup_by_name, `preview_window_${winnr}`);
    pcall(vim.api.nvim_win_close, winnr, true);
  };
  vim.schedule(fn);
}
