import { RightClickIndexes } from "@conf/base";
import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "Wansmer/treesj",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    cmd: ["TSJToggle", "TSJSplit", "TSJJoin"],
    opts: {
      use_default_keymaps: false,
      check_syntax_error: false,
      max_join_length: 120,
    },
    config: true,
  },
    allowInVscode: true,
  extends: {
    commands: [
      {
        name: "Toggle Split/Join",
        enabled: (buffer) => {
          return buffer.tsHighlighter.length > 0;
        },
        callback: () => {
          vim.api.nvim_command("TSJToggle");
        },
        rightClick: {
          title: "Split/Join",
          keys: ["t"],
          index: RightClickIndexes.treesj,
        },
      },
    ],
  },
};

export default new Plugin(spec);
