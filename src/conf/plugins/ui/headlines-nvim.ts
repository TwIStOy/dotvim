import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "lukas-reineke/headlines.nvim",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    ft: ["markdown", "vimwiki"],
    config: true,
  },
});
