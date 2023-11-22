import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "3rd/image.nvim",
  lazy: {
    lazy: true,
  }
}

export const plugin = new Plugin(spec);
