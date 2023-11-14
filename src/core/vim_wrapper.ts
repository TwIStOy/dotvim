type IsTSAny<T> = 0 extends 1 & T ? true : false;
type IsLuaTable<T> = T extends LuaTable ? true : false;

type IsAny<T> = IsTSAny<T> extends true ? true : IsLuaTable<T>;

type Combine<T extends any[]> = T extends [infer A, ...infer B]
  ? IsAny<A> extends true
    ? any
    : B["length"] extends 0 // T is [A]
    ? A
    : A & Combine<B>
  : never;

export function tblExtend<T extends any[]>(
  behavior: "error" | "keep" | "force",
  ...tbls: T
): Combine<T> {
  return vim.tbl_extend(behavior, ...tbls);
}
