import { ActionGroupBuilder, Plugin, PluginOpts, andActions } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "dstein64/vim-startuptime",
  lazy: {
    cmd: "StartupTime",
    config() {
      vim.g.startuptime_tries = 10;
    },
  },
  extends: {
    commands: {
      category: "VimStartuptime",
      commands: [
        {
          name: "StartupTime",
          description: "Show Vim's startup time",
          callback: "StartupTime",
        },
      ],
    },
  },
};

const group = new ActionGroupBuilder()
    .from("vim-startuptime")
    .category("StartupTime")
    .addOpts({
      id: "vim-startuptime.show",
      title: "Show Vim's startup time",
      callback: () => {
        vim.api.nvim_command("StartupTime");
      },
    })

export const plugin = new Plugin(andActions(spec, group.build()));
