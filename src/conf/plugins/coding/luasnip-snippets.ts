import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "TwIStOy/luasnip-snippets",
  lazy: {
    dev: true,
    dependencies: ["L3MON4D3/LuaSnip"],
    event: ["InsertEnter"],
    config: () => {
      luaRequire("luasnip-snippets").setup({
        user: {
          name: "Hawtian Wang",
        },
      });
    },
  },
};

export const plugin = new Plugin(spec);
