import WhichKey from "./which-key";
import StartupTime from "./vim-startuptime";
import Conform from "./edit/conform";

export const AllPlugins = [WhichKey, StartupTime, Conform];

export const LazySpecs = AllPlugins.map((p) => p.asLazySpec());
