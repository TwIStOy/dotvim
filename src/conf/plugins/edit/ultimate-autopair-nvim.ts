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
      config_internal_pairs: [
        {
          [1]: "'",
          [2]: "'",
          suround: true,
          cond: (fn: AnyMod) => {
            return !fn.in_lisp() || fn.in_string();
          },
          alpha: true,
          nft: ["tex", "rust"],
          multiline: false,
        },
      ],
    },
    config: true,
  },
});
