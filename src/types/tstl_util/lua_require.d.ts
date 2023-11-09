/** @noSelfInFile */
interface AnyMod {
  [key: string]: (this: void, ...args: any[]) => any;
}

declare function luaRequire(modname: string): AnyMod;
