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
  ---@type dora.core.plugin
  local plugin = require("dora.core.plugin")

  config.setup(opts or {})

  local specs = {}
  local packages = config.package.sorted_package()
  for _, pkg in ipairs(packages) do
    for _, plug_opts in ipairs(pkg:plugins()) do
      local plug = plugin.new_plugin(plug_opts)
      registry.register_plugin(plug)
      specs[#specs + 1] = plug:into_lazy_spec()
    end
  end

  bootstrap_lazy_nvim()

  require("lazy").setup {
    spec = specs,
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

  for _, pkg in ipairs(packages) do
    pkg:setup()
  end
end

return M
