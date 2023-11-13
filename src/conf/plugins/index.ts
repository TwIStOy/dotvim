import WhichKey from "./which-key";
import StartupTime from "./vim-startuptime";
import editPlugins from "./edit";
import lspPlugins from "./lsp";
import { AllLspServers } from "../external_tools";

export const AllPlugins = [
  WhichKey,
  StartupTime,
  ...editPlugins,
  ...lspPlugins,
  ...AllLspServers,
];

export const LazySpecs = AllPlugins.map((p) => p.asLazySpec());

