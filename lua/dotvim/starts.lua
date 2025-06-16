local function install_missing_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  ---@diagnostic disable-next-line: undefined-field
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
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.rtp:prepend(lazypath)
end

-- set mapleader at very beginning of profile
vim.api.nvim_set_var("mapleader", " ")

install_missing_lazy()
require("lazy").setup {
  root = vim.fn.stdpath("data") .. "/lazy2", -- directory where plugins will be installed
  lockfile = vim.fn.stdpath("config") .. "/lazy2-lock.json", -- lockfile generated after running update.
  spec = {
    { import = "dotvim.plugins" },
    { import = "dotvim.plugins.langs" },
  },
  performance = {
    cache = { enabled = true },
    rtp = {
      paths = {
        os.getenv("HOME") .. "/.dotvim",
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

require("dotvim.configs")
