import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "NvChad/nvim-colorizer.lua",
  lazy: {
    ft: ["vim", "lua"],
    cmd: [
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
      "ColorizerToggle",
    ],
    opts: {
      filetypes: ["vim", "lua"],
      user_default_options: {
        RRGGBB: true,
        names: false,
        AARRGGBB: true,
        mode: "virtualtext",
      },
    },
    config: (_, opts) => {
      luaRequire("colorizer").setup(opts);

      let ft = vim.api.nvim_get_option_value("filetype", {
        buf: 0,
      });
      if (ft == "vim" || ft == "lua") {
        luaRequire("colorizer").attach_to_buffer(0);
      }
    },
  },
};

export const plugin = new Plugin(spec);
