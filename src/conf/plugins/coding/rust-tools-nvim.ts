import {
  ActionGroupBuilder,
  Plugin,
  andActions,
  buildSimpleCommand,
} from "@core/model";

export const plugin = new Plugin(
  andActions(
    {
      shortUrl: "simrat39/rust-tools.nvim",
      lazy: {
        lazy: true,
        dependencies: ["nvim-lua/plenary.nvim", "mfussenegger/nvim-dap"],
      },
      extends: {
        commands: {
          category: "RustTools",
          enabled: (buf) => {
            for (const server of buf.lspServers) {
              if (server.name === "rust_analyzer") return true;
            }
            return false;
          },
          commands: [
            buildSimpleCommand("Open cargo.toml of this file", () => {
              luaRequire("rust-tools").open_cargo_toml.open_cargo_toml();
            }),
            buildSimpleCommand("Open parent module of this file", () => {
              luaRequire("rust-tools").parent_module.parent_module();
            }),
          ],
        },
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
        .build();
    }
  )
);
