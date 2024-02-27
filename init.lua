vim.opt.rtp:prepend("~/Projects/dora.nvim")

---@class dora
local dora = require("dora")

dora.setup {
  nixpkgs = {
    ["gh-actions-nvim"] = "/nix/store/kll18h07ii8sjb2gp2hyd5vsag6j2yp7-vimplugin-gh-actions-nvim-2024-02-20",
    ["markdown-preview-nvim"] = "/nix/store/dwzd4ffqszzqxa4vgyc444n6fgzz1riy-vimplugin-markdown-preview.nvim-2023-10-17",
    ["telescope-fzf-native-nvim"] = "/nix/store/xxzx9jgj1cwpkssgmbw3giqw8b68fas9-vimplugin-telescope-fzf-native.nvim-2023-09-10",
  },
  packages = {
    "coding",
    "editor",
    "treesitter",
    "lsp",
    "ui",
    "extra.editor",
    "extra.lang.cpp",
    "extra.lang.latex",
    "extra.lang.markdown",
    "extra.lang.rust",
    "extra.misc.competitive-programming",
    "extra.misc.copilot",
  },
}

vim.cmd([[
colorscheme catppuccin
]])
