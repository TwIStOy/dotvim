import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
  buildSimpleCommand,
} from "@core/model";
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
  allowInVscode: true,
};

function actions() {
  return ActionGroupBuilder.start()
    .category("Template")
    .addOpts({
      id: "template.expand-template-into-current-buffer",
      title: "Expand template into current buffer",
      callback: inputArgsAndExec("Template"),
      description: "Expand a mated template fron the beginning of the buffer",
    })
    .addOpts({
      id: "template.expand-template-under-cursor",
      title: "Expand template under cursor",
      callback: inputArgsAndExec("TemplateHere"),
      description: "Expand a matched template under the cursor",
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, actions));
