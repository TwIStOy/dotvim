/** @noSelfInFile **/

declare type LspEvents =
  | "LspAttach"
  | "LspDetach"
  | "LspNotify"
  | "LspProgress"
  | "LspRequest"
  | "LspTokenUpdate";

declare type AutocmdEvent =
  | "BufAdd"
  | "BufDelete"
  | "BufEnter"
  | "BufFilePost"
  | "BufFilePre"
  | "BufAdd"
  | "BufDelete"
  | "BufEnter"
  | "BufFilePost"
  | "BufFilePre"
  | "BufHidden"
  | "BufLeave"
  | "BufModifiedSet"
  | "BufNew"
  | "BufNewFile"
  | "BufRead"
  | "BufReadPost"
  | "BufReadCmd"
  | "BufReadPre"
  | "BufUnload"
  | "BufWinEnter"
  | "BufWinLeave"
  | "BufWipeout"
  | "BufWrite"
  | "BufWritePre"
  | "BufWriteCmd"
  | "BufWritePost"
  | "ChanInfo"
  | "ChanOpen"
  | "CmdUndefined"
  | "CmdlineChanged"
  | "CmdlineEnter"
  | "CmdlineLeave"
  | "CmdwinEnter"
  | "CmdwinLeave"
  | "ColorScheme"
  | "ColorSchemePre"
  | "CompleteChanged"
  | "CompleteDonePre"
  | "CompleteDone"
  | "CursorHold"
  | "CursorHoldI"
  | "CursorMoved"
  | "CursorMovedI"
  | "DiffUpdated"
  | "DirChanged"
  | "DirChangedPre"
  | "ExitPre"
  | "FileAppendCmd"
  | "FileAppendPost"
  | "FileAppendPre"
  | "FileChangedRO"
  | "FileChangedShell"
  | "FileChangedShellPost"
  | "FileReadCmd"
  | "FileReadPost"
  | "FileReadPre"
  | "FileType"
  | "FileWriteCmd"
  | "FileWritePost"
  | "FileWritePre"
  | "FilterReadPost"
  | "FilterReadPre"
  | "FilterWritePost"
  | "FilterWritePre"
  | "FocusGained"
  | "FocusLost"
  | "FuncUndefined"
  | "UIEnter"
  | "UILeave"
  | "InsertChange"
  | "InsertCharPre"
  | "InsertEnter"
  | "InsertLeavePre"
  | "InsertLeave"
  | "MenuPopup"
  | "ModeChanged"
  | "OptionSet"
  | "QuickFixCmdPre"
  | "QuickFixCmdPost"
  | "QuitPre"
  | "RemoteReply"
  | "SearchWrapped"
  | "RecordingEnter"
  | "RecordingLeave"
  | "SafeState"
  | "SessionLoadPost"
  | "ShellCmdPost"
  | "Signal"
  | "ShellFilterPost"
  | "SourcePre"
  | "SourcePost"
  | "SourceCmd"
  | "SpellFileMissing"
  | "StdinReadPost"
  | "StdinReadPre"
  | "SwapExists"
  | "Syntax"
  | "TabEnter"
  | "TabLeave"
  | "TabNew"
  | "TabNewEntered"
  | "TabClosed"
  | "TermOpen"
  | "TermEnter"
  | "TermLeave"
  | "TermClose"
  | "TermResponse"
  | "TextChanged"
  | "TextChangedI"
  | "TextChangedP"
  | "TextChangedT"
  | "TextYankPost"
  | "User"
  | "UserGettingBored"
  | "VimEnter"
  | "VimLeave"
  | "VimLeavePre"
  | "VimResized"
  | "VimResume"
  | "VimSuspend"
  | "WinClosed"
  | "WinEnter"
  | "WinLeave"
  | "WinNew"
  | "WinScrolled"
  | "WinResized";

declare namespace vim {
  /**
   * Special value representing NIL in |RPC| and |v:null| in Vimscript
   * conversion, and similar cases. Lua `nil` cannot be used as part of a
   * Lua table representing a Dictionary or Array, because it is treated as
   * missing: `{"foo", nil}` is the same as `{"foo"}`.
   */
  export const NIL: null;

  /**
   * "Pretty prints" the given arguments and returns them unmodified.
   */
  export function print(...args: any[]): any[];

  /**
   * Global (`g:`) editor variables.
   * Key with no value returns `nil`.
   */
  export const g: AnyTable;

  export const o: AnyTable;

  export const v: AnyTable;

  export const uv: AnyMod;

  export const opt_local: AnyTable;

  export const env: LuaTable;

  export namespace json {
    /**
     * Encodes (or "packs") Lua object `{obj}` as JSON in a Lua string.
     */
    export function encode(value: any): string;

    /**
     * Decodes (or "unpacks") the JSON-encoded `{str}` to a Lua object.
     *
     * - Decodes JSON "null" to `vim.NIL`.
     * - Decodes empty object as `vim.empty_dict()`.
     * - Decodes empty array as `{}` (empty lua table)
     */
    export function decode(
      str: string,
      opts?: {
        luanil?: {
          /**
           * When true, converts `null` in JSON objects to Lua `nil` instead of
           * `vim.NIL`.
           */
          object?: boolean;
          /**
           * When true, converts `null` in JSON arrays to Lua `nil` instead of
           * `vim.NIL`.
           */
          array?: boolean;
        };
      }
    ): any;
  }

  export namespace log {
    export namespace levels {
      export const DEBUG: number;
      export const ERROR: number;
      export const INFO: number;
      export const TRACE: number;
      export const WARN: number;
      export const OFF: number;
    }
  }

  export namespace base64 {
    export function decode(str: string): string;
    export function encode(str: string): string;
  }

  /**
   * Defers calling `fn` untile `timeout` ms passes.
   *
   * Use to do a one-shot timer that calls `fn`.
   * Note: The `fn` is `vim.schedule_wrap()`ped automatically, so API functions
   * are safe to call.
   *
   * @param fn Callback to call once `timeout` expires.
   * @param timeout Number of milliseconds to wait before calling `fn`.
   */
  // FIXME(hawtian): return type should be a luv timer object
  export function defer_fn(fn: () => void, timeout: number): void;

  /**
   * Displays a notification to the user.
   */
  export function notify(
    msg: string,
    level?: number,
    opts?: notify.Options
  ): void;

  /**
   * Returns a function which calls `fn` via `vim.schedule()`.
   */
  export function schedule_wrap(fn: () => void): () => void;

  /**
   * Schedules `fn` to be invoked soon by the main event-loop. Useful to avoid
   * `textlock` or other temporary restrictions.
   */
  export function schedule(fn: () => void): void;

  /**
   * Merge two or more tables.
   */
  export function tbl_extend(
    behavior: "error" | "keep" | "force",
    ...tbls: any[]
  ): any;

  export function tbl_deep_extend(
    behavior: "error" | "keep" | "force",
    ...tbls: any[]
  ): any;

  export interface SystemCompleted {
    code: number;
    signal: number;
    stdout: string | null;
    stderr: string | null;
  }

  /**
   * Runs a system command or throws an error if `cmd` cannot be run.
   *
   * @param cmd Command to run.
   */
  export function system(
    cmd: string[],
    opts?: {
      cwd?: string;
      env?: LuaTable<string, string>;
      clear_env?: boolean;
      stdin?: string | string[] | boolean;
      stdout?: boolean | ((err: string, data: string) => void);
      stderr?: boolean | ((err: string, data: string) => void);
      text?: boolean;
      timeout?: number;
      detach?: boolean;
    },
    on_exit?: (comp: SystemCompleted) => void
  ): {
    pid: number;
    wait: (timeout?: number) => SystemCompleted;
    kill: (signal: string | number) => void;
    /*
     * Requires `stdin=true`. Pass `nil` to close stdin.
     */
    write: (data: string | null) => void;
    is_close: () => boolean;
  };

  export function inspect(value: any): string;

  export function uri_from_fname(this: void, uri: string): string;

  export function uri_to_bufnr(this: void, uri: string): number;

  export function tbl_keys(this: void, val: AnyTable): string[];

  export function split(
    this: void,
    str: string,
    sep: string,
    opts?: {
      plain?: boolean;
      trimempty?: boolean;
    }
  ): string[];

  export function str_utf_pos(
    this: void,
    str: string,
    index?: number
  ): number[];

  export function wait(
    timeout: number,
    condition: () => boolean,
    interval?: number
  ): 0 | -1 | -2 | -3;
}
