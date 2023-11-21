import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "altermo/ultimate-autopair.nvim",
  lazy: {
    event: ["InsertEnter", "CmdlineEnter"],
    opts: {
      close: {
        map: "<M-0>",
        cmap: "<M-0>",
      },
      tabout: {
        hopout: true,
      },
    },
    config: true,
  },
});
