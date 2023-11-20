import { Plugin, buildSimpleCommand } from "@core/model";

export default new Plugin({
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
});
