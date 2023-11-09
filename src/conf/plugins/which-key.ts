import { PluginOpts } from "../../core/plugin";
import * as wk from "which-key-raw-nvim";

export const spec: PluginOpts<"folke/which-key.nvim"> = {
  shortUrl: "folke/which-key.nvim",
  lazy: {
    event: "VeryLazy",
    opts: {
      key_labels: { ["<space>"]: "SPC", ["<cr>"]: "RET", ["<tab>"]: "TAB" },
      layout: { align: "center" },
      ignore_missing: false,
      hidden: ["<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "],
      show_help: true,
      icons: { breadcrumb: "»", separator: "|", group: "+" },
    },
    config(_plug, opts) {
      // let wk = require("which-key");
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
    },
  },
};
