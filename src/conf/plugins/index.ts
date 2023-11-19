import { AllLspServers } from "@conf/external_tools";
import WhichKey from "./which-key";
import StartupTime from "./vim-startuptime";
import editPlugins from "./edit";
import lspPlugins from "./lsp";
import uiPlugins from "./ui";
import otherPlugins from "./other";
import codingPlugins from "./coding";
import treesitterPlugins from "./treesitter";

export const AllPlugins = [
  WhichKey,
  StartupTime,
  ...editPlugins,
  ...lspPlugins,
  ...uiPlugins,
  ...otherPlugins,
  ...codingPlugins,
  ...treesitterPlugins,
];

export const LazySpecs = [...AllPlugins, ...AllLspServers].map((p) =>
  p.asLazySpec()
);
