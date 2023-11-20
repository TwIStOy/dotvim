import { Plugin } from "@core/model";

export default new Plugin({
  shortUrl: "topaxi/gh-actions.nvim",
  lazy: {
    cmd: ["GhActions"],
    build: "make",
    dependencies: ["nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"],
    config: true,
  },
});
