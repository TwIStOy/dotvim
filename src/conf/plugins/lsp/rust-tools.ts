import { Plugin, PluginOpts } from "../../../core/plugin";

const spec: PluginOpts = {
  shortUrl: "simrat39/rust-tools.nvim",
  lazy: {
    lazy: true,
    dependencies: ["nvim-lua/plenary.nvim", "mfussenegger/nvim-dap"],
  },
  extends: {
    commands: {
      category: "RustTools",
      commands: [
      ]
    }
  }
};

export default new Plugin(spec);
