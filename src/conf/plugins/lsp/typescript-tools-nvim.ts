import { Plugin, PluginOpts } from "@core/plugin";
import { buildSimpleCommand } from "@core/types";

export const spec: PluginOpts = {
  shortUrl: "pmizio/typescript-tools.nvim",
  lazy: {
    lazy: true,
    dependencies: ["nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"],
    cmd: [
      "TSToolsOrganizeImports",
      "TSToolsSortImports",
      "TSToolsRemoveUnusedImports",
      "TSToolsRemoveUnused",
      "TSToolsAddMissingImports",
      "TSToolsFixAll",
      "TSToolsGoToSourceDefinition",
      "TSToolsRenameFile",
    ],
  },
  extends: {
    allowInVscode: false,
    commands: {
      category: "TSTools",
      commands: [
        buildSimpleCommand(
          "Sorts and removes unused imports",
          "TSToolsOrganizeImports"
        ),
        buildSimpleCommand("Sorts imports", "TSToolsSortImports"),
        buildSimpleCommand(
          "Removes unused imports",
          "TSToolsRemoveUnusedImports"
        ),
        buildSimpleCommand(
          "Removes all unused statements",
          "TSToolsRemoveUnused"
        ),
        buildSimpleCommand(
          "Adds imports for all statements that lack one and can be imported",
          "TSToolsAddMissingImports"
        ),
        buildSimpleCommand(
          "Fixes all fixable erros in the current file",
          "TSToolsFixAll"
        ),
        buildSimpleCommand(
          "Go to the source definition",
          "TSToolsGoToSourceDefinition"
        ),
        buildSimpleCommand(
          "Rename file and apply changes to connected files",
          "TSToolsRenameFile"
        ),
      ],
    },
  },
};

export default new Plugin(spec);
