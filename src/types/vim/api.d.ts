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

    export interface AutocmdCallbackArg {
      /**
       * autocommand id
       */
      id: number;
      /**
       * name of the triggered event `autocmd-events`
       */
      event: string;
      /**
       * autocommand group id, if any
       */
      group?: number;
      /**
       * expanded value of `<amatch>`
       */
      match: string;
      /**
       * expanded value of `<abuf>`
       */
      buf: number;
      /**
       * expanded value of `<afile>`
       */
      file: string;
      /**
       * arbitrary data passed from `nvim_evec_autocmds()`
       */
      data: AnyTable;
    }

    export function nvim_create_augroup(
      name: string,
      opts?: {
        clear?: boolean;
      }
    ): number;

    /**
     * Creates an **autocommand** event handler, defined by `callback` or `command`.
     */
    export function nvim_create_autocmd(
      /**
       * Event(s) that will trigger the handler (`callback` or `command`).
       */
      event: string | string[],
      opts: {
        /**
         * autocommand group name or id to match against.
         */
        group?: string | number;
        /**
         * pattern(s) to match literally `autocomd-pattern`.
         */
        pattern?: string | string[];
        /**
         * buffer number for buffer-local autocommands `autocmd-bufferlocal`.
         * Cannot be used with `pattern`.
         */
        buffer?: number;
        /**
         * description (for documentation and troubleshooting).
         */
        desc?: string;
        /**
         * Lua function (or Vimscript function name, if string) called when
         * the event(s) is triggered. Lua callback can return true to delete
         * the autocommand, and receives a table argument.
         */
        callback?:
          | string
          | ((this: void, arg: AutocmdCallbackArg) => boolean | void);
        /**
         * Vim command to execute on event. Cannot be used with `callback`.
         */
        command?: string;
        /**
         * defaults to false. Run the autocommand only once `autocmd-once`.
         */
        once?: boolean;
        /**
         * defaults to false. Run nested autocommands `autocmd-nested`.
         */
        nested?: boolean;
      }
    ): void;

    /**
     * Gets the value of an option.
     */
    export function nvim_get_option_value(
      name: string,
      opts?: {
        scope?: "global" | "local";
        /**
         * used for getting window local options;
         */
        win?: number;
        /**
         * Buffer number. Used for getting buffer local options. Implies
         * `scope` is "local".
         */
        buf?: number;
        /**
         * Used to get the default option for a specific filetype.
         * Cannot be used with any other option.
         *
         * Note: this will trigger `ftplugin` and all `FileType` autocommands
         * for the corresponding filetype.
         */
        filetype?: string;
      }
    ): any;

    /**
     * Gets the full file name for the buffer.
     *
     * @param buffer Buffer handle, or 0 for current buffer.
     * @return Full file name of the buffer.
     */
    export function nvim_buf_get_name(buffer: number): string;

    /**
     * Gets the current buffer.
     */
    export function nvim_get_current_buf(): number;

    /**
     * Gets the current line string.
     */
    export function nvim_get_current_line(): string;

    /**
     * Delete an autocommand group by name.
     */
    export function nvim_del_augroup_by_name(name: string): void;

    /**
     * Delete an autocommand group by id.
     */
    export function nvim_del_augroup_by_id(id: number): void;

    /**
     * Closes the window (like `:close` with a `window-id`).
     *
     * NOTE: Not allowed when `textlock` is active.
     *
     * @param window Window handle, or 0 for current window.
     * @param force Force close window, even if it has a modified buffer.
     */
    export function nvim_win_close(window: number, force?: boolean): void;

    /**
     * Calculates the number of display cells occupied by `string`.
     */
    export function nvim_strwidth(str: string): number;

    /**
     * @returns Id of the created/updated extmark.
     */
    export function nvim_buf_set_extmark(
      buffer: number,
      ns_id: number,
      line: number,
      col: number,
      opts: {}
    ): number;

    export function nvim_get_current_win(): number;

    export function nvim_win_set_cursor(
      window: number,
      pos: [number, number]
    ): void;

    export function nvim_set_current_win(win: number): void;
  }
}
