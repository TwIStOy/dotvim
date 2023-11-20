import { Plugin } from "@core/model";

export default new Plugin({
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
