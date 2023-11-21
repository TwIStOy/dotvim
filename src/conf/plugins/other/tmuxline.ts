import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

const spec: PluginOpts = {
  shortUrl: "edkolev/tmuxline.vim",
  lazy: {
    lazy: true,
    cmd: ["Tmuxline"],
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Tmuxline")
    .addOpts({
      id: "tmuxline.update",
      title: "Update current tmux theme",
      callback: () => {
        vim.api.nvim_command("Tmuxline");
      },
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
