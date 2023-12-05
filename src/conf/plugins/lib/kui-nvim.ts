import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "romgrk/kui.nvim",
  lazy: {
    lazy: true,
    dependencies: ["romgrk/kui-demo.nvim"],
  },
};

export const plugin = new Plugin(spec);
