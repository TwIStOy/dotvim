import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "s1n7ax/nvim-window-picker",
  lazy: {
    lazy: true,
    config: true,
    opts: {
      filter_rules: {
        bo: {
          filetype: ["NvimTree", "neo-tree", "notify", "NvimSeparator"],
          buftype: ["terminal"],
        },
      },
    },
  },
});
