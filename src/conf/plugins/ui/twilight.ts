import { Plugin, PluginOpts } from "../../../core/plugin";

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

export default new Plugin(spec);
