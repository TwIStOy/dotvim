---@type dotvim.core.plugin.PluginOption
return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "plenary.nvim",
    "nvim-web-devicons",
    "nui-components.nvim",
  },
  cmd = {
    "Spectre",
  },
  opts = function(_, opts)
    ---@type dotvim.utils
    local Utils = require("dotvim.utils")

    opts.find_engine = {
      ["rg"] = {
        cmd = Utils.which("rg"),
      },
      ["ag"] = {
        cmd = Utils.which("ag"),
      },
    }
    opts.replace_engine = {
      ["sed"] = {
        cmd = Utils.which("sed"),
      },
      ["oxi"] = {
        cmd = Utils.which("oxi"),
      },
      ["sd"] = {
        cmd = Utils.which("sd"),
      },
    }
    return opts
  end,
  actions = {
    {
      id = "spectre.open",
      title = "Open Spectre",
      callback = function()
        require("spectre").open()
      end,
    },
  },
}
