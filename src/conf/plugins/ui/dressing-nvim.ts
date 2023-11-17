import { Plugin } from "@core/plugin";

export default new Plugin({
  shortUrl: "stevearc/dressing.nvim",
  lazy: {
    lazy: true,
    config: true,
    opts: {
      input: {
        title_pos: "center",
        relative: "editor",
        insert_only: true,
        start_in_insert: true,
      },
    },
    init: () => {
      (vim.ui as any as LuaTable).set("select", (...args: any[]) => {
        luaRequire("lazy").load({ plugins: ["dressing.nvim"] });
        return vim.ui.select(...args);
      });
      (vim.ui as any as LuaTable).set("input", (opts: any, f: any) => {
        luaRequire("lazy").load({ plugins: ["dressing.nvim"] });
        return vim.ui.input(opts, f);
      });
    },
  },
});
