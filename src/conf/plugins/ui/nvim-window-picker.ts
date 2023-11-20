import { Plugin } from "@core/model";

export default new Plugin({
  shortUrl: "s1n7ax/nvim-window-picker",
  lazy: {
    lazy: true,
    config: true,
    opts: {
      filter_rules: {
        bo: {
          filetype: ["NvimTree", "neo-tree", "notify"],
          buftype: ["terminal"],
        },
      },
    },
  },
});
