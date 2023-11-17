import { Plugin } from "@core/plugin";

export default new Plugin({
  shortUrl: "lukas-reineke/headlines.nvim",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    ft: ["markdown", "vimwiki"],
    config: true,
  },
});
