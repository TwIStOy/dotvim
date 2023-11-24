import { AllPlugins } from "@conf/plugins";
import { Plugin, PluginActionIds, TraitActionsId } from "@core/model";
import { TupleToUnion } from "@core/type_traits";
import { builtinActions } from "./builtin";

export type AvailableActions = TupleToUnion<
  [
    ...MergePluginsActionsMaybeGroup<
      RemoveReadonlyFromTuple<typeof AllPlugins>
    >,
    ...TraitActionsId<RemoveReadonlyFromTuple<typeof builtinActions>>,
  ]
>;

type MergePluginsActionsMaybeGroup<Ps extends any[]> = Ps extends [
  infer P,
  ...infer Rest,
]
  ? [...MaybePluginOrPluginList<P>, ...MergePluginsActionsMaybeGroup<Rest>]
  : [];

type MaybePluginOrPluginList<P> = P extends Plugin<any>[]
  ? MergePluginsActions<P>
  : P extends Plugin<any>
  ? PluginActionIds<P>
  : never;

type RemoveReadonlyFromTuple<T extends readonly any[]> = T extends readonly [
  infer A,
  ...infer Rest,
]
  ? A extends readonly any[]
    ? [RemoveReadonlyFromTuple<A>, ...RemoveReadonlyFromTuple<Rest>]
    : [A, ...RemoveReadonlyFromTuple<Rest>]
  : T;

type MergePluginsActions<Ps extends Plugin<any>[]> = Ps extends [
  infer P,
  ...infer Rest,
]
  ? P extends Plugin<any>
    ? Rest extends Plugin<any>[]
      ? [...PluginActionIds<P>, ...MergePluginsActions<Rest>]
      : never
    : never
  : [];
