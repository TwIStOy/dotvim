import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "p00f/clangd_extensions.nvim",
  lazy: {
    lazy: true,
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Clangd")
    .from("clangd_extensions.nvim")
    .condition((buf) => {
      for (let server of buf.lspServers) {
        if (server.name === "clangd") {
          return true;
        }
      }
      return false;
    })
    .addOpts({
      id: "clangd.switch-source-header",
      title: "Switch between source and header files",
      callback: "ClangdSwitchSourceHeader",
    })
    .addOpts({
      id: "clangd.view-ast",
      title: "View AST",
      callback: "ClangdAST",
    })
    .addOpts({
      id: "clangd.view-type-hierarchy",
      title: "View type hierarchy",
      callback: "ClangdTypeHierarchy",
    })
    .addOpts({
      id: "clangd.symbol-info",
      title: "Symbol info",
      callback: "ClangdSymbolInfo",
    })
    .addOpts({
      id: "clangd.memory-usage",
      title: "Memory usage",
      callback: "ClangdMemoryUsage",
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
