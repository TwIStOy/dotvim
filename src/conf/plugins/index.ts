import { plug as WhichKey } from "./which-key";
import { plug as StartupTime } from "./vim-startuptime";

export const AllPlugins = [WhichKey, StartupTime];

export const LazySpecs = AllPlugins.map((p) => p.asLazySpec());
