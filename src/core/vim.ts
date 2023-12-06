/** @noSelfInFile **/

import { HasNil, Last } from "./type_traits";

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
export function isNil(v: any): v is null | undefined {
  return v === undefined || v === null || v === vim.NIL;
}

type IfNilRet<T extends any[]> =
  | Exclude<T[number], null | undefined>
  | (HasNil<Last<T>> extends true ? null : never);

/**
 * @brief Return the first non-nil value.
 */
export function ifNil<T extends any[]>(...args: T): IfNilRet<T> {
  for (let i = 0; i < args.length - 1; i++) {
    if (!isNil(args[i])) {
      return args[i];
    }
  }
  return args[args.length - 1];
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

export function inputArgsAndExec(cmd: string) {
  return () => {
    vim.ui.input(
      {
        prompt: `Arguments, ${cmd}`,
      },
      (input) => {
        if (input) {
          if (input.length > 0) {
            vim.api.nvim_command(`${cmd} ${input}`);
          } else {
            vim.api.nvim_command(cmd);
          }
        }
      }
    );
  };
}

export function isExiting() {
  return !isNil(vim.v.exiting);
}

let _savedCursor: string | null = null;
export function hideCursor() {
  if (_savedCursor === null) {
    _savedCursor = vim.api.nvim_get_option_value("guicursor", {
      scope: "global",
    });
  }
  // schedule this, since otherwise Neovide crashes
  vim.schedule(() => {
    if (_savedCursor !== null) {
      vim.api.nvim_set_option_value("guicursor", "a:NoiceHiddenCursor", {
        scope: "global",
      });
    }
  });
}

export function showCursor() {
  if (_savedCursor !== null && !isExiting()) {
    vim.schedule(() => {
      if (_savedCursor !== null && !isExiting()) {
        vim.api.nvim_set_option_value("guicursor", "a:", {
          scope: "global",
        });
        vim.api.nvim_command("redrawstatus");
        vim.api.nvim_set_option_value("guicursor", _savedCursor, {
          scope: "global",
        });
        _savedCursor = null;
      }
    });
  }
}

/**
 * Redraw all UI elements.
 */
export function redrawAll() {
  vim.api.nvim_command("redrawstatus!");
  vim.api.nvim_command("redraw!");
}

/**
 * Get foreground color of a highlight.
 */
export function highlightFg(group: string): string {
  let hl = vim.api.nvim_get_hl(0, {
    name: group,
  });
  let fg = hl.get("fg");
  if (!isNil(fg) && fg !== "") {
    return string.format("#%x", fg);
  }
  return "";
}

export function system(
  cmd: string[],
  opts?: any
): Promise<vim.SystemCompleted> {
  return new Promise<vim.SystemCompleted>((resolve, reject) => {
    const onExit = (obj: vim.SystemCompleted) => {
      resolve(obj);
    };
    try {
      vim.system(cmd, opts, onExit);
    } catch (e) {
      reject(e);
    }
  });
}

export function systemSync(cmd: string[], opts?: any): vim.SystemCompleted {
  return vim.system(cmd, opts).wait();
}

export function sleep(ms: number): Promise<void> {
  return new Promise<void>((resolve) => {
    vim.defer_fn(() => {
      resolve();
    }, ms);
  });
}
