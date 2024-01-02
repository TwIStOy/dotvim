import { Plugin } from "@core/model";
import { isNil } from "@core/vim";

export const plugin = new Plugin({
  shortUrl: "lukas-reineke/headlines.nvim",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    enabled: isNil(vim.g.neovide),
    ft: ["markdown", "vimwiki"],
    config: true,
  },
});
