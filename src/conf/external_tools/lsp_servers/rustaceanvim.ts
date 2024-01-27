import { ActionGroupBuilder, LspServer, Plugin, andActions } from "@core/model";
import { inputArgsAndExec } from "@core/vim";
import { HttsContext } from "context";

const plugin = new Plugin(
  andActions(
    {
      shortUrl: "mrcjkb/rustaceanvim",
      lazy: {
        version: "^3",
        lazy: true,
        // ft: ["rust"],
        dependencies: ["nvim-lua/plenary.nvim", "mfussenegger/nvim-dap"],
      },
    },
    () => {
      return new ActionGroupBuilder()
        .from("rustaceanvim")
        .category("Rustaceanvim")
        .condition((buf) => {
          for (const server of buf.lspServers) {
            if (server.name === "rust-analyzer") return true;
          }
          return false;
        })
        .addOpts({
          id: "rustaceanvim.expand-macro",
          title: "Expand macro",
          callback: () => {
            vim.api.nvim_command("RustLsp expandMacro");
          },
        })
        .addOpts({
          id: "rustaceanvim.rebuild-proc-macro",
          title: "Rebuild proc macro",
          callback: () => {
            vim.api.nvim_command("RustLsp rebuildProcMacros");
          },
        })
        .addOpts({
          id: "rustaceanvim.move-item-up",
          title: "Move item up",
          callback: () => {
            vim.api.nvim_command("RustLsp moveItem up");
          },
        })
        .addOpts({
          id: "rustaceanvim.move-item-down",
          title: "Move item down",
          callback: () => {
            vim.api.nvim_command("RustLsp moveItem down");
          },
        })
        .addOpts({
          id: "rustaceanvim.hover-actions",
          title: "Hover actions",
          callback: () => {
            vim.api.nvim_command("RustLsp hover actions");
          },
        })
        .addOpts({
          id: "rustaceanvim.hover-range",
          title: "Hover range",
          callback: () => {
            vim.api.nvim_command("RustLsp hover range");
          },
        })
        .addOpts({
          id: "rustaceanvim.explain-errors",
          title: "Explain errors",
          callback: () => {
            vim.api.nvim_command("RustLsp explainError");
          },
        })
        .addOpts({
          id: "rustaceanvim.render-diagnostic",
          title: "Render diagnostic",
          callback: () => {
            vim.api.nvim_command("RustLsp renderDiagnostic");
          },
        })
        .addOpts({
          id: "rustaceanvim.open-cargo-toml",
          title: "Open cargo.toml of this file",
          callback: () => {
            vim.api.nvim_command("RustLsp openCargo");
          },
        })
        .addOpts({
          id: "rustaceanvim.open-parent-module",
          title: "Open parent module of this file",
          callback: () => {
            vim.api.nvim_command("RustLsp parentModule");
          },
        })
        .addOpts({
          id: "rustaceanvim.join-lines",
          title: "Join lines",
          callback: () => {
            vim.api.nvim_command("RustLsp joinLines");
          },
        })
        .addOpts({
          id: "rustaceanvim.structural-search-replace",
          title: "Structural search replace",
          callback: () => {
            inputArgsAndExec("RustLsp ssr");
          },
        })
        .addOpts({
          id: "rustaceanvim.view-syntax-tree",
          title: "View syntax tree",
          callback: () => {
            vim.api.nvim_command("RustLsp syntaxTree");
          },
        })
        .build();
    }
  )
);

export const server = new LspServer({
  name: "rust-analyzer",
  plugin,
  exe: false,
  setup: (_, on_attach, capabilities) => {
    vim.g.rustaceanvim = {
      tools: {
        on_initialized: () => {
          vim.notify("rust-analyzer initialize done");
        },
        inlay_hints: { auto: true },
      },
      server: {
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
    };

    luaRequire("lazy").load({ plugins: ["rustaceanvim"] });
  },
});
