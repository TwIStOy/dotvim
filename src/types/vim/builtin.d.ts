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
}
