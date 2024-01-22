import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "willothy/flatten.nvim",
  lazy: {
    lazy: false,
    priority: 1001,
    config: true,
    opts: {
      window: {
        open: "alternate",
      },
    },
  },
});
