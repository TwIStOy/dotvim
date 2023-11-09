/** @noSelfInFile **/

declare namespace vim {
  export namespace api {
    /**
     * Gets the (1,0)-indexed, buffer-relative cursor position for a given
     * window (different windows showing the same buffer have independent
     * cursor positions).
     *
     * @param window Window handle, or 0 for current window.
     * @return [row, col] tuple
     * @see `getcurpos()`
     */
    export function nvim_win_get_cursor(window: number): [number, number];

    /**
     * Executes an Ex command.
     *
     * @param Ex command string.
     */
    export function nvim_command(command: string): void;
  }
}
