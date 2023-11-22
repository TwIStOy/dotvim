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

    export function fnamemodify(fname: string, mods: string): string;

    export function setreg(reg: string, val: any, options?: any): void;
  }
}
