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

/**
 * Unique array elements.
 *
 * @param arr Array to unique.
 * @returns A new array with unique elements.
 */
export function uniqueArray<T>(arr: T[]): T[] {
  return Array.from(new Set(arr));
}
