/** @noSelfInFile */

interface AnyMod {
  [key: string]: AnyMod;
  (this: void, ...args: any[]): any;
}

declare function luaRequire(this: void, modname: string): AnyMod;

declare function __raw_import(this: void, modname: string): AnyMod;
