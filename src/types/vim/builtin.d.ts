/** @noSelfInFile **/

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
}
