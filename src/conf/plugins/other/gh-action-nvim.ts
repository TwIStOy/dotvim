import { Plugin } from "@core/model";
import { ifNil } from "@core/vim";

export const plugin = new Plugin({
  shortUrl: "topaxi/gh-actions.nvim",
  lazy: {
    cmd: ["GhActions"],
    dir: ifNil(nix_plugins, new LuaTable()).get("gh-actions-nvim"),
    dependencies: ["nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"],
    opts: {},
    config: (_, opts) => {
      luaRequire("gh-actions").setup(opts);
    },
  },
});
