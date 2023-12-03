/**
 * Returns the last element.
 */
export type Last<T extends any[]> = [never, ...T][T["length"]];

export type HasNil<T> = T extends null | undefined ? true : false;

export type ExcludeNilSingle<T> = Exclude<T, null | undefined>;

export type Push<T extends any[], U> = [...T, U];

export type Concat<T extends any[], U extends any[]> = [...T, ...U];

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

type Unionize<T extends unknown[] | unknown> = T extends unknown[]
  ? T[number]
  : T;

export type Without<T extends unknown[], U> = T extends [
  infer Head,
  ...infer Rest,
]
  ? Head extends Unionize<U>
    ? Without<Rest, U>
    : [Head, ...Without<Rest, U>]
  : [];

export type TupleToUnion<T extends unknown[]> = T[number];

export type IsSame<T, U> = [T] extends [U]
  ? [U] extends [T]
    ? true
    : false
  : false;

export type GetRequired<
  T,
  U extends Required<T> = Required<T>,
  K extends keyof T = keyof T,
> = Pick<T, K extends keyof T ? (T[K] extends U[K] ? K : never) : never>;

export type Writeable<T> = { -readonly [P in keyof T]: T[P] };

export type DeepWriteable<T> = {
  -readonly [P in keyof T]: DeepWriteable<T[P]>;
};

export type RemoveReadonlyFromTuple<T extends readonly any[]> =
  T extends readonly [infer A, ...infer Rest]
    ? A extends readonly any[]
      ? [RemoveReadonlyFromTuple<A>, ...RemoveReadonlyFromTuple<Rest>]
      : [A, ...RemoveReadonlyFromTuple<Rest>]
    : T;
