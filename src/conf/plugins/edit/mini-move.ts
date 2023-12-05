import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "echasnovski/mini.move",
  lazy: {
    opts: {
      mappings: {
        left: "<C-h>",
        right: "<C-l>",
        down: "<C-j>",
        up: "<C-k>",
        line_left: "<C-h>",
        line_right: "<C-l>",
        line_down: "<C-j>",
        line_up: "<C-k>",
      },
    },
    keys: [
      { [1]: "<C-h>", [2]: null, mode: ["n", "v"] },
      { [1]: "<C-j>", [2]: null, mode: ["n", "v"] },
      { [1]: "<C-k>", [2]: null, mode: ["n", "v"] },
      { [1]: "<C-l>", [2]: null, mode: ["n", "v"] },
    ],
    config: (_, opts) => {
      luaRequire("mini.move").setup(opts);
    },
  },
  allowInVscode: true,
};

export const plugin = new Plugin(spec);
