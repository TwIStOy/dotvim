import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "altermo/ultimate-autopair.nvim",
  lazy: {
    event: ["InsertEnter", "CmdlineEnter"],
    opts: {
      close: {
        map: "<C-0>",
        cmap: "<C-0>",
      },
      tabout: {
        hopout: true,
      },
      fastwarp: {
        enable: true,
        map: "<C-=>",
        rmap: "<C-->",
        cmap: "<C-=>",
        crmap: "<C-->",
        enable_normal: true,
        enable_reverse: true,
        hopout: false,
        multiline: true,
        nocursormove: true,
        no_nothing_if_fail: false,
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
