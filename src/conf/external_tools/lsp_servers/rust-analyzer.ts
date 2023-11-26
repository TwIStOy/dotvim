import { ActionGroupBuilder, LspServer, Plugin, andActions } from "@core/model";
import { HttsContext } from "context";

const plugin = new Plugin(
  andActions(
    {
      shortUrl: "simrat39/rust-tools.nvim",
      lazy: {
        lazy: true,
        dependencies: ["nvim-lua/plenary.nvim", "mfussenegger/nvim-dap"],
      },
    },
    () => {
      return new ActionGroupBuilder()
        .from("rust-tools")
        .category("RustTools")
        .condition((buf) => {
          for (const server of buf.lspServers) {
            if (server.name === "rust_analyzer") return true;
          }
          return false;
        })
        .addOpts({
          id: "rust-tools.open-cargo-toml",
          title: "Open cargo.toml of this file",
          callback: () => {
            luaRequire("rust-tools").open_cargo_toml.open_cargo_toml();
          },
        })
        .addOpts({
          id: "rust-tools.open-parent-module",
          title: "Open parent module of this file",
          callback: () => {
            luaRequire("rust-tools").parent_module.parent_module();
          },
        })
        .addOpts({
          id: "rust-tools.hover-actions",
          title: "Hover actions",
          callback: () => {
            luaRequire("rust-tools").hover_actions.hover_actions();
          },
        })
        .addOpts({
          id: "rust-tools.move-items-up",
          title: "Move items up",
          callback: () => {
            luaRequire("rust-tools").move_item.move_item(true);
          },
        })
        .addOpts({
          id: "rust-tools.join-lines",
          title: "Join lines",
          callback: () => {
            luaRequire("rust-tools").join_lines.join_lines();
          },
        })
        .addOpts({
          id: "rust-tools.expand-macro",
          title: "Expand macro",
          callback: () => {
            luaRequire("rust-tools").expand_macro.expand_macro();
          },
        })
        .build();
    }
  )
);

export const server = new LspServer({
  name: "rust-analyzer",
  plugin,
  exe: {
    masonPkg: "rust-analyzer",
  },
  setup: (_server, on_attach, capabilities) => {
    luaRequire("rust-tools").setup({
      tools: {
        on_initialized: () => {
          vim.notify("rust-analyzer initialize done");
        },
        inlay_hints: { auto: true },
      },
      server: {
        cmd: [HttsContext.getInstance().masonBinRoot + "/rust-analyzer"],
        on_attach: on_attach,
        capabilities: capabilities,
        settings: {
          ["rust-analyzer"]: {
            cargo: { buildScripts: { enable: true } },
            procMacro: { enable: true },
            check: {
              command: "clippy",
              extraArgs: ["--all", "--", "-W", "clippy::all"],
            },
            completion: { privateEditable: { enable: true } },
            diagnostic: {
              enable: true,
              disabled: ["inactive-code"],
            },
          },
        },
      },
    });
  },
});
