/** @noSelfInFile **/

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
  }
}
