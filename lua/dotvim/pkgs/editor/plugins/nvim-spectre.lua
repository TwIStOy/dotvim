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
    opts.live_update = true

    return opts
  end,
  config = function(_, opts)
    require("spectre").setup(opts)
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "spectre_panel",
      callback = function()
        vim.api.nvim_buf_set_keymap(
          0,
          "n",
          "r",
          [[<cmd>lua require("spectre.actions").run_current_replace()<CR>]],
          { noremap = true, silent = true }
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
