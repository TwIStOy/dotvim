import { AllPlugins } from "@conf/plugins";
import {
  LspServer,
  Plugin,
  PluginActionIds,
  TraitActionsId,
} from "@core/model";
import { RemoveReadonlyFromTuple, TupleToUnion } from "@core/type_traits";
import { builtinActions } from "./builtin";
import { AllLspServers } from "@conf/external_tools";

export type AvailableActions = TupleToUnion<
  [
    ...MergePluginsActionsMaybeGroup<
      RemoveReadonlyFromTuple<typeof AllPlugins>
    >,
    ...TraitActionsId<RemoveReadonlyFromTuple<typeof builtinActions>>,
    ...MergePluginsActionsMaybeGroup<
      LazyServersIntoPlugin<RemoveReadonlyFromTuple<typeof AllLspServers>>
    >,
  ]
>;

type LazyServerIntoPlugin<P extends LspServer<any>> = P extends LspServer<
  infer AIds
>
  ? Plugin<AIds>
  : never;

type LazyServersIntoPlugin<P extends LspServer<any>[]> = P extends [
  infer F,
  ...infer R,
]
  ? F extends LspServer<any>
    ? R extends LspServer<any>[]
      ? [LazyServerIntoPlugin<F>, ...LazyServersIntoPlugin<R>]
      : never
    : never
  : [];

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
