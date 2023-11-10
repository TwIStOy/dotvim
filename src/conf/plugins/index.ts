import WhichKey from "./which-key";
import StartupTime from "./vim-startuptime";
import editPlugins from "./edit";
import lspPlugins from "./lsp";

export const AllPlugins = [
  WhichKey,
  StartupTime,
  ...editPlugins,
  ...lspPlugins,
];

export const LazySpecs = AllPlugins.map((p) => p.asLazySpec());
