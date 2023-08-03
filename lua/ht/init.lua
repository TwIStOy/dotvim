local Const = require("ht.core.const")

local function bootstrap_plugin_manager()
  if not vim.uv.fs_stat(Const.lazy_path) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      Const.lazy_path,
    }
  end
  vim.opt.rtp:prepend(Const.lazy_path)

  local lazy_settings = {
    spec = {
      { import = "ht.plugins" },
      { import = "ht.plugins.edit" },
      { import = "ht.plugins.external" },
      { import = "ht.plugins.ui" },
      { import = "ht.plugins.lsp" },
      { import = "ht.plugins.coding" },
      { import = "ht.plugins.tree-sitter" },
      { import = "ht.plugins.theme" },
    },
    change_detection = { enabled = false },
    lockfile = vim.env.HOME .. "/.dotvim/lazy-lock.json",
    dev = { path = vim.env.HOME .. "/Projects/nvim-plugins" },
    performance = {
      cache = { enabled = true },
      install = { colorscheme = { "tokyonight", "habamax" } },
      rtp = {
        paths = { "~/.dotvim" },
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

  if Const.os.is_macos then
    lazy_settings.concurrency = 20
  end

  require("lazy").setup(lazy_settings)

  local FF = require("ht.core.functions")
  FF:add_function_set {
    category = "Lazy",
    functions = {
      title = "Check health",
      f = function()
        vim.cmd("checkhealth")
      end,
    },
  }
  FF:add_function_set {
    category = "Lazy",
    functions = {
      {
        title = "Rebuild a plugin",
        f = ExecFunc("Lazy build"),
      },
      {
        title = "Check for updates and show the log (git fetch)",
        f = ExecFunc("Lazy check"),
      },
      {
        title = "Clean plugins that are no longer needed",
        f = ExecFunc("Lazy clean"),
      },
      {
        title = "Clear finished tasks",
        f = function()
          vim.cmd("Lazy clear")
        end,
      },
      {
        title = "Show debug information",
        f = function()
          vim.cmd("Lazy debug")
        end,
      },
      {
        title = "Show detailed profiling",
        f = function()
          vim.cmd("Lazy profile")
        end,
      },
      {
        title = "Run install, clean and update",
        f = ExecFunc("Lazy sync"),
      },
      {
        title = "Update plugins. This will also update the lockfile",
        f = ExecFunc("Lazy update"),
      },
    },
  }
end

require("ht._G")

-- set mapleader at very beginning of profile
vim.api.nvim_set_var("mapleader", " ")

-- delay noftify invocations
require("ht.utils").delay_notify_invocations()

bootstrap_plugin_manager()

require("ht.settings")
require("ht.conf.event")

local mkdir = require("ht.features.mkdir")

mkdir.register_create_directory_before_save()
