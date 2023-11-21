import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "topaxi/gh-actions.nvim",
  lazy: {
    cmd: ["GhActions"],
    build: "make",
    dependencies: ["nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"],
    config: true,
  },
});
