import { Plugin } from "@core/plugin";

export default new Plugin({
  shortUrl: "pwntester/octo.nvim",
  lazy: {
    dependencies: [
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    ],
    cmd: ["Octo"],
    opts: {
      default_remote: ["origin", "upstream"],
    },
    config: true,
  },
});
