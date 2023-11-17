import { Plugin, PluginOpts } from "@core/plugin";

const spec: PluginOpts = {
  shortUrl: "edkolev/tmuxline.vim",
  lazy: {
    lazy: true,
    cmd: ["Tmuxline"],
  },
  extends: {
    commands: [
      {
        name: "Update current tmux theme",
        callback: () => {
          vim.api.nvim_command("Tmuxline");
        },
      },
    ],
  },
};

export default new Plugin(spec);
