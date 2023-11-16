/**
 * Returns the last element.
 */
export type Last<T extends any[]> = [never, ...T][T["length"]];

export type HasNil<T> = T extends null | undefined ? true : false;

export type ExcludeNilSingle<T> = Exclude<T, null | undefined>;

/**
 * Returns the type exclude nil types(`null` and `undefined`).
 */
export type ExcludeNil<T> = T extends [infer F, ...infer R]
  ? [ExcludeNil<F>, ...ExcludeNil<[...R]>]
  : T extends object
  ? {
      [K in keyof T]: ExcludeNil<T[K]>;
    }
  : ExcludeNilSingle<T>;

