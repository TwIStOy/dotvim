/**
 * @brief Get the cursor position in the current window.
 * @param winnr number?
 * @returns [number, number] Both indexes are 0-based.
 */
export function getCursor0Index(winnr?: number): [number, number] {
    winnr = winnr || 0;
    let c = vim.api.nvim_win_get_cursor(winnr);
    c[0] = c[0] - 1;
    return c;
}

/**
 * @brief Check if a value is nil or vim.NIL.
 */
export function isNil(v: any): boolean {
    return v === undefined || v === null || v === vim.NIL;
}
