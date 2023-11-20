import { Plugin, PluginOpts, buildSimpleCommand } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "mrjones2014/dash.nvim",
  lazy: {
    build: "make install",
    cmd: ["Dash", "DashWord"],
    enabled: () => {
      return vim.uv.os_uname().sysname === "Darwin";
    },
    opts: {
      dash_app_path: "/Applications/Setapp/Dash.app",
      search_engine: "google",
      file_type_keywords: {
        dashboard: false,
        NvimTree: false,
        TelescopePrompt: false,
        terminal: false,
        packer: false,
        fzf: false,
      },
    },
    config: true,
  },
  extends: {
    commands: [buildSimpleCommand("Search Dash", "Dash")],
  },
};

export default new Plugin(spec);
