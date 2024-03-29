import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "folke/twilight.nvim",
  lazy: {
    cmd: ["Twilight", "TwilightEnable", "TwilightDisable"],
    event: "BufReadPost",
    enabled: false,
    config: true,
    opts: {
      expand: ["function", "method"],
    },
  },
};

export const plugin = new Plugin(spec);
