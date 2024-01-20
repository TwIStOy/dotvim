import { Plugin } from "@core/model";

export const plugin = new Plugin({
  shortUrl: "Bekaboo/dropbar.nvim",
  lazy: {
    dependencies: [
      "nvim-telescope/telescope-fzf-native.nvim",
    ],
  }
});
