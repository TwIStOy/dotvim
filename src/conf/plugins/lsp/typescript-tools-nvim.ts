import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
  buildSimpleCommand,
} from "@core/model";

function generateActions() {
  return ActionGroupBuilder.start()
    .category("TSTools")
    .from("typescript-tools.nvim")
    .addOpts({
      id: "typescript-tools.organize-imports",
      title: "Sorts and removes unused imports",
      callback: "TSToolsOrganizeImports",
    })
    .addOpts({
      id: "typescript-tools.sort-imports",
      title: "Sorts imports",
      callback: "TSToolsSortImports",
    })
    .addOpts({
      id: "typescript-tools.remove-unused-imports",
      title: "Removes unused imports",
      callback: "TSToolsRemoveUnusedImports",
    })
    .addOpts({
      id: "typescript-tools.remove-unused",
      title: "Removes all unused statements",
      callback: "TSToolsRemoveUnused",
    })
    .addOpts({
      id: "typescript-tools.add-missing-imports",
      title:
        "Adds imports for all statements that lack one and can be imported",
      callback: "TSToolsAddMissingImports",
    })
    .addOpts({
      id: "typescript-tools.fix-all",
      title: "Fixes all fixable erros in the current file",
      callback: "TSToolsFixAll",
    })
    .addOpts({
      id: "typescript-tools.go-to-source-definition",
      title: "Go to the source definition",
      callback: "TSToolsGoToSourceDefinition",
    })
    .addOpts({
      id: "typescript-tools.rename-file",
      title: "Rename file and apply changes to connected files",
      callback: "TSToolsRenameFile",
    })
    .build();
}

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
  allowInVscode: false,
};

export const plugin = new Plugin(andActions(spec, generateActions));
