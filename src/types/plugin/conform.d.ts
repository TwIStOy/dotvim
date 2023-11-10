/** @noSelfInFile **/

declare namespace conform {
  export interface Context {
    buf: number;
    filename: string;
    dirname: string;
    range?: Range;
  }

  export interface Range {
    start: number[];
    end: number[];
  }

  export type RangeContext = Context & { range: Range };

  export interface JobFormatterConfig {
    command: string | ((this: void, ctx: Context) => string);
    args?:
      | string
      | string[]
      | ((this: void, ctx: Context) => string | string[]);
    range_args?:
      | string
      | string[]
      | ((this: void, ctx: RangeContext) => string | string[]);
    cwd?: (this: void, ctx: Context) => string | undefined;
    /**
     * When `cwd` is not found, don't run the formatter (default `false`)
     */
    require_cwd?: boolean;
    /**
     * Send buffer contents to stdin (default `true`)
     */
    stdin?: boolean;
    /**
     * Exit codes that indicate success (default `{0}`)
     */
    exit_codes?: number[];
    /**
     * Environment variables for formatter.
     */
    env?: LuaTable | ((this: void, ctx: Context) => LuaTable);
    /**
     * Whether the formatter is enabled.
     */
    condition?: (this: void, ctx: Context) => boolean;
  }
}
