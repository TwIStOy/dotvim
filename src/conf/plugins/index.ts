import WhichKey from "./which-key";
import StartupTime from "./vim-startuptime";
import editPlugins from "./edit";
import lspPlugins from "./lsp";
import { AllLspServers } from "../external_tools";
import uiPlugins from "./ui";

export const AllPlugins = [
  WhichKey,
  StartupTime,
  ...editPlugins,
  ...lspPlugins,
  ...uiPlugins,
  ...AllLspServers,
];

export const LazySpecs = AllPlugins.map((p) => p.asLazySpec());

