/** @noSelfInFile **/

interface ReltimeItem {}

declare namespace vim {
  export namespace fn {
    export type StdPathInput =
      | "cache"
      | "config"
      | "config_dirs"
      | "data"
      | "data_dirs"
      | "log"
      | "run"
      | "state";

    /**
     * Returns `standard-path` locations of various default files and
     * directories.
     */
    export function stdpath(path: StdPathInput): string;

    export function has(varname: string): number;

    /**
     * The number of display cells `string` occupies.
     */
    export function strwidth(str: string): number;

    export function reltime(start?: ReltimeItem): ReltimeItem;

    export function reltimefloat(x: ReltimeItem): number;

    export function line(str: string): number;

    export function win_getid(win?: number, tab?: number): number;

    export function winnr(
      arg?:
        | "$"
        | "#"
        | `${number | ""}h`
        | `${number | ""}j`
        | `${number | ""}k`
        | `${number | ""}l`
    ): number;

    export function getcwd(winnr?: number, tabnr?: number): string;

    export function expand(
      expr: string,
      nosuf?: boolean,
      list?: boolean
    ): string;

    export function fnamemodify(
      this: void,
      fname: string,
      mods: string
    ): string;

    export function setreg(reg: string, val: any, options?: any): void;

    export function trim(s: string): string;

    export function jobstart(cmd: string, opts?: any): number;

    export function rpcnotify(
      this: void,
      channel: number,
      method: string,
      args?: any[]
    ): void;

    export function sockconnect(
      this: void,
      mode: "tcp" | "pipe",
      address: string,
      opts?: any
    ): number;
  }
}
