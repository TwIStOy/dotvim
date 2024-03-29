import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "folke/drop.nvim",
  lazy: {
    event: "VimEnter",
    config: true,
    enabled: false,
    opts: {
      theme: "snow",
      screensaver: false,
    },
  },
};

export const plugin = new Plugin(spec);
