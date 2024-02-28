vim.opt.rtp:prepend("~/Projects/dora.nvim")

---@class dora
local dora = require("dora")

dora.setup {
  nix = {
    pkgs = {
      ["gh-actions-nvim"] = "/nix/store/kll18h07ii8sjb2gp2hyd5vsag6j2yp7-vimplugin-gh-actions-nvim-2024-02-20",
      ["markdown-preview-nvim"] = "/nix/store/dwzd4ffqszzqxa4vgyc444n6fgzz1riy-vimplugin-markdown-preview.nvim-2023-10-17",
      ["telescope-fzf-native-nvim"] = "/nix/store/xxzx9jgj1cwpkssgmbw3giqw8b68fas9-vimplugin-telescope-fzf-native.nvim-2023-09-10",
    },
  },
  packages = {
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
    "dora.packages.extra.lang.lua",
    "dora.packages.extra.lang.latex",
    "dora.packages.extra.lang.markdown",
    "dora.packages.extra.lang.rust",
    "dora.packages.extra.misc.competitive-programming",
    "dora.packages.extra.misc.copilot",
  },
}

vim.cmd([[
colorscheme catppuccin
]])
