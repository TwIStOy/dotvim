import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "dstein64/nvim-scrollview",
  lazy: {
    enabled: false,
    event: ["BufReadPost"],
    dependencies: ["kevinhwang91/nvim-hlslens", "folke/tokyonight.nvim"],
    opts: {
      excluded_filetypes: [
        "prompt",
        "TelescopePrompt",
        "noice",
        "toggleterm",
        "nuipopup",
        "NvimTree",
        "rightclickpopup",
      ],
      current_only: true,
      winblend: 75,
      base: "right",
      column: 2,
      signs_on_startup: ["all"],
    },
    config: true,
  },
};

export const plugin = new Plugin(spec);
