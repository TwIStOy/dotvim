local function bootstrap_lazy_nvim()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end

---@class dora
local M = {}

---@param opts? dora.config.SetupOptions
function M.setup(opts)
  ---@type dora.config
  local config = require("dora.config")

  ---@type dora.core.registry
  local registry = require("dora.core.registry")

  config.setup(opts or {})

  ---@param plug dora.core.plugin.Plugin
  local plugin_specs = vim.tbl_map(function(plug)
    return plug:into_lazy_spec()
  end, registry.sort_plugins())

  bootstrap_lazy_nvim()

  require("lazy").setup {
    spec = plugin_specs,
    change_detection = { enabled = false },
    install = {
      missing = true,
    },
    performance = {
      cache = { enabled = true },
      install = { colorscheme = { "tokyonight", "habamax" } },
      rtp = {
        paths = {
          "~/Projects/dora.nvim",
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
end

return M
