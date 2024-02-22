import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "topaxi/gh-actions.nvim",
  nixPath: "gh-actions-nvim",
  lazy: {
    cmd: ["GhActions"],
    dependencies: ["nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"],
    build: "make",
    opts: {},
    config: (_, opts) => {
      luaRequire("gh-actions").setup(opts);
    },
  },
});
