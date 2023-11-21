import { RightClickIndexes } from "@conf/base";
import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

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
};

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Treesj")
    .from("treesj")
    .addOpts({
      id: "treesj.toggle",
      title: "Toggle Split/Join",
      callback: "TSJToggle",
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
