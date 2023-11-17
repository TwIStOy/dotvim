import { Plugin, PluginOpts } from "@core/plugin";
import { buildSimpleCommand } from "@core/types";
import { inputArgsAndExec } from "@core/vim";

const spec: PluginOpts = {
  shortUrl: "aperezdc/vim-template",
  lazy: {
    cmd: ["Template", "TemplateHere"],
    init: () => {
      vim.g.templates_directory = [
        `${os.getenv("HOME")}/.dotvim/vim-templates`,
      ];
      vim.g.templates_no_autocmd = 0;
      vim.g.templates_debug = 0;
      vim.g.templates_no_builtin_templates = 1;
    },
  },
  extends: {
    allowInVscode: true,
    commands: [
      buildSimpleCommand(
        "Expand template into current buffer",
        inputArgsAndExec("Template")
      ),
      buildSimpleCommand(
        "Expand template under cursor",
        inputArgsAndExec("TemplateHere"),
        "This command works exactly the same except that it will expand a " +
          "matched template under the cursor instead of at the beginning of " +
          "the buffer."
      ),
    ],
  },
};

export default new Plugin(spec);
