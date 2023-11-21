import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
  buildSimpleCommand,
} from "@core/model";

function dashEnabled() {
  return vim.uv.os_uname().sysname === "Darwin";
}

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Dash")
    .from("dash.nvim")
    .condition(dashEnabled)
    .addOpts({
      id: "dash.search",
      title: "Search Dash",
      callback: "Dash",
    })
    .addOpts({
      id: "dash.search-word",
      title: "Search Dash for the word under the cursor",
      callback: "DashWord",
    })
    .build();
}

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
};

export const plugin = new Plugin(andActions(spec, generateActions));
