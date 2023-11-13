import { Plugin, PluginOpts } from "../../../core/plugin";

const spec: PluginOpts = {
  shortUrl: "pmizio/typescript-tools.nvim",
  lazy: {
    dependencies: ["nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"],
    config : true,
  },
};

export default new Plugin(spec);
