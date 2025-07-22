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
    opts.mapping = {
      ["toggle_line"] = {
        cmd = false,
      },
      ["send_to_qf"] = {
        cmd = false,
      },
      ["run_current_replace"] = {
        cmd = false,
      },
      ["run_replace"] = {
        cmd = false,
      },
    }

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
    opts.live_update = true

    return opts
  end,
  config = function(_, opts)
    require("spectre").setup(opts)
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "spectre_panel",
      callback = function()
        require("dotvim.extra.hydra").create_hydra(
          require("dotvim.pkgs.editor.plugins.nvim-spectre.hydra")()
        )
      end,
    })
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
