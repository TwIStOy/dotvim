import { Plugin } from "@core/plugin";

export default new Plugin({
  shortUrl: "danymat/neogen",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    cmd: ["Neogen"],
    opts: {
      input_after_comment: false,
    },
    config: true,
  },
});
