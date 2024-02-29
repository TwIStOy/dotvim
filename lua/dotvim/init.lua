local function install_missing_dora()
  local dora_path = vim.fn.stdpath("data") .. "/lazy/dora.nvim"

  if not vim.uv.fs_stat(dora_path) then
    vim
      .system({
        "git",
        "clone",
        "https://github.com/TwIStOy/dora.nvim.git",
        dora_path,
      })
      :wait()
  end

  vim.opt.rtp:prepend(dora_path)
end

local M = {}

function M.setup(opts)
  install_missing_dora()

  ---@class dora
  local dora = require("dora")

  opts = opts or {}

  opts.packages = {
    "dora.packages._builtin",
    "dora.packages.coding",
    "dora.packages.editor",
    "dora.packages.treesitter",
    "dora.packages.lsp",
    "dora.packages.ui",
    "dora.packages.extra.ui",
    "dora.packages.extra.misc.tools",
    "dora.packages.extra.misc.darwin",
    "dora.packages.extra.editor",
    "dora.packages.extra.lang.cpp",
    "dora.packages.extra.lang.cmake",
    "dora.packages.extra.lang.lua",
    "dora.packages.extra.lang.latex",
    "dora.packages.extra.lang.markdown",
    "dora.packages.extra.lang.python",
    "dora.packages.extra.lang.rust",
    "dora.packages.extra.lang.dart",
    "dora.packages.extra.lang.swift",
    "dora.packages.extra.lang.typescript",
    "dora.packages.extra.lang.nix",
    "dora.packages.extra.misc.competitive-programming",
    "dora.packages.extra.obsidian",
    "dora.packages.extra.misc.copilot",
    "dora.packages.extra.misc.wakatime",
    "dora.packages.extra.misc.rime",

    "dotvim.packages.obsidian",
    "dotvim.packages.lsp",
  }

  dora.setup(opts)

  vim.cmd("colorscheme catppuccin")
end

return M
