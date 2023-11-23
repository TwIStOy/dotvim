import { LazyKeySpec } from "types/plugin/lazy";

export type TypedKeySpec<
  K extends string,
  Mode extends string[] = ["n"],
  Ft extends string[] | undefined = undefined,
  Desc extends string | undefined = undefined,
  Silent extends boolean = false,
> = {
  lhs: K;
  mode: Mode;
  ft: Ft;
  desc: Desc;
  silent: Silent;
};

export function intoKeySpec<
  K extends string,
  Mode extends string[],
  Ft extends string[] | undefined,
  Desc extends string | undefined,
  Silent extends boolean,
>(
  spec: TypedKeySpec<K, Mode, Ft, Desc, Silent>
): Omit<LazyKeySpec, 2> {
  return {
    [1]: spec.lhs,
    mode: spec.mode,
    ft: spec.ft,
    desc: spec.desc,
    silent: spec.silent,
  }
}
