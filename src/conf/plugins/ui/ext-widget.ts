import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "TwIStOy/external-widget.nvim",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    event: "VeryLazy",
    dev: true,
    build: "cargo build --release",
    config: () => {
      luaRequire("external-widget.config").setup({});
    },
  },
});
