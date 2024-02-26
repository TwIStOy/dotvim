---@class dora.config.configs.Lazy: LazyCoreConfig
local M = {
  spec = specs,
  change_detection = { enabled = false },
  dev = {
    path = "~/Projects/nvim-plugins",
    patterns = { "TwIStOy" },
    fallback = true,
  },
  install = {
    missing = true,
  },
  performance = {
    cache = { enabled = true },
    install = { colorscheme = { "tokyonight", "habamax" } },
    rtp = {
      paths = {
        "~/.dotvim",
        "~/.local/share/dotvim",
      },
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "spellfile",
      },
    },
  },
}

return M
