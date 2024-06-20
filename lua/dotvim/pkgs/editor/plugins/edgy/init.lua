---@type dotvim.core.plugin.PluginOption
return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.splitkeep = "screen"
  end,
  opts = {
    left = {
      ---@type Edgy.View.Opts
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        pinned = true,
        size = { height = 0.5, width = 30 },
        open = "Neotree action=show",
      },
      {
        ft = "Outline",
        title = "Outline",
        pinned = true,
        open = "Outline!",
      },
    },
    bottom = {
      {
        ft = "spectre_panel",
        title = "Spectre",
        size = {
          height = 0.4,
        },
      },
      {
        ft = "trouble",
        title = "Trouble",
      },
      {
        ft = "qf",
        title = "Quickfix",
        size = {
          height = 0.3,
        },
      },
    },
    animate = {
      enabled = false,
    },
    options = {
      left = { size = 32 },
      bottom = { size = 10 },
      right = { size = 30 },
      top = { size = 10 },
    },
    exit_when_last = true,
    close_when_all_hidden = true,
    wo = {
      -- Setting to `true`, will add an edgy winbar.
      -- Setting to `false`, won't set any winbar.
      -- Setting to a string, will set the winbar to that string.
      winbar = true,
      winfixwidth = true,
      winfixheight = false,
      winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
      spell = false,
      signcolumn = "no",
    },
    -- buffer-local keymaps to be added to edgebar buffers.
    -- Existing buffer-local keymaps will never be overridden.
    -- Set to false to disable a builtin.
    ---@type table<string, fun(win:Edgy.Window)|false>
    keys = {
      ["W"] = function(win)
        local opts = require("dotvim.pkgs.editor.plugins.edgy.hydra")(win)
        local hydra = require("dotvim.extra.hydra").create_hydra(opts)
        hydra:activate()
      end,
      -- close window
      ["q"] = function(win)
        win:close()
      end,
    },
    icons = {
      closed = "󰍜 ",
      open = "󰮫 ",
    },
    -- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
    -- Not needed on a nightly build >= June 5, 2023.
    fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
  },
}
