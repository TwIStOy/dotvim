import { Plugin, PluginOpts } from "@core/model";
import { toIcon } from "@core/utils/string";

const spec: PluginOpts = {
  shortUrl: "folke/which-key.nvim",
  lazy: {
    event: "VeryLazy",
    opts: {
      key_labels: { ["<space>"]: "SPC", ["<cr>"]: "RET", ["<tab>"]: "TAB" },
      layout: { align: "center" },
      ignore_missing: false,
      hidden: ["<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "],
      show_help: true,
      icons: { breadcrumb: "»", separator: toIcon("f0734"), group: "+" },
    },
    config(_plug, opts) {
      vim.defer_fn(() => {
        let wk = luaRequire("which-key");
        wk.setup(opts);
        wk.register({
          mode: ["n", "v"],

          ["g"]: { name: "+goto" },
          ["]"]: { name: "+next" },
          ["["]: { name: "+prev" },

          ["<leader>b"]: { name: "+build" },
          ["<leader>f"]: { name: "+file" },
          ["<leader>l"]: { name: "+list" },
          ["<leader>n"]: { name: "+no" },
          ["<leader>p"]: { name: "+preview" },
          ["<leader>r"]: { name: "+remote" },
          ["<leader>t"]: { name: "+toggle" },
          ["<leader>v"]: { name: "+vcs" },
          ["<leader>w"]: { name: "+window" },
          ["<leader>x"]: { name: "+xray" },
        });
      }, 100);
    },
  },
};

export const plugin = new Plugin(spec);
