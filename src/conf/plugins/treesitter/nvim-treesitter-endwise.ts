import { Plugin } from "@core/plugin";

export default new Plugin({
  shortUrl: "RRethy/nvim-treesitter-endwise",
  lazy: {
    ft: ["lua", "ruby", "vimscript"],
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    config: () => {
      luaRequire("nvim-treesitter.configs").setup({
        endwise: { enable: true },
      });
    },
  },
  extends: {
    allowInVscode: true,
  },
});
