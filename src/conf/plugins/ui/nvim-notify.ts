import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "rcarriga/nvim-notify",
  lazy: {
    dependencies: ["nvim-tree/nvim-web-devicons"],
    lazy: true,
    opts: {
      timeout: 3000,
      stages: "static",
      fps: 60,
      max_height: () => {
        return Math.floor(
          vim.api.nvim_get_option_value("lines", {
            scope: "global",
          }) * 0.75
        );
      },
      max_width: () => {
        return Math.floor(
          vim.api.nvim_get_option_value("columns", {
            scope: "global",
          }) * 0.75
        );
      },
    },
    config: (_, opts) => {
      vim.defer_fn(() => {
        luaRequire("notify").setup(opts);
      }, 30);
    },
  },
  extends: {
    commands: [
      {
        name: "List notify histories using telescope",
        callback: () => {
          luaRequire("telescope").extensions.notify.notify();
        },
        keys: "<leader>lh",
        shortDesc: "notify-history",
      },
      {
        name: "Dismiss all notifications",
        callback: () => {
          luaRequire("notify").dismiss({
            silent: true,
            pending: true,
          });
        },
        keys: "<leader>nn",
        shortDesc: "notify-dismiss",
      },
    ],
  },
};

export const plugin = new Plugin(spec);
