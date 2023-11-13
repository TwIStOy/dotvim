/** @noSelfInFile */

interface AnyMod {
  [key: string]: AnyMod;
  (this: void, ...args:any[]): any;
}

declare function luaRequire(modname: string): AnyMod;
