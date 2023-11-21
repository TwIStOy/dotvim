import { AllLspServers } from "@conf/external_tools";
import { plugin as WhichKey } from "./which-key";
import { plugin as StartupTime } from "./vim-startuptime";
import { plugins as editPlugins } from "./edit";
import { plugins as lspPlugins } from "./lsp";
import { plugins as uiPlugins } from "./ui";
import { plugins as otherPlugins } from "./other";
import { plugins as codingPlugins } from "./coding";
import { plugins as treesitterPlugins } from "./treesitter";
import { Plugin, PluginActionIds } from "@core/model";
import { TupleToUnion } from "@core/type_traits";

export const AllPlugins = [
  WhichKey,
  StartupTime,
  editPlugins,
  lspPlugins,
  uiPlugins,
  otherPlugins,
  codingPlugins,
  treesitterPlugins,
] as const;

export const LazySpecs = [...AllPlugins, ...AllLspServers]
  .flat()
  .map((p) => p.asLazySpec());

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

type MaybePluginOrPluginList<P> = P extends Plugin<any>[]
  ? MergePluginsActions<P>
  : P extends Plugin<any>
  ? PluginActionIds<P>
  : never;

type MergePluginsActionsMaybeGroup<Ps extends any[]> = Ps extends [
  infer P,
  ...infer Rest,
]
  ? [...MaybePluginOrPluginList<P>, ...MergePluginsActionsMaybeGroup<Rest>]
  : [];

export type AvailableActions = TupleToUnion<
  MergePluginsActionsMaybeGroup<RemoveReadonlyFromTuple<typeof AllPlugins>>
>;
