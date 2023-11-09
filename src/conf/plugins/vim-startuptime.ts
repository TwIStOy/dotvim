import { Plugin, PluginOpts } from "../../core/plugin";

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

export const plug = new Plugin(spec);
