import { Plugin } from "@core/model";
import { isNil } from "@core/vim";

export const plugin = new Plugin({
  shortUrl: "TwIStOy/external-widget.nvim",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    event: "VeryLazy",
    dev: true,
    enabled: isNil(vim.g.neovide),
    build: "cargo build --release",
    config: () => {
      luaRequire("external-widget.config").setup({});
    },
  },
});
