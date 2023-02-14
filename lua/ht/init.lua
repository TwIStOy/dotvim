local function bootstrap_plugin_manager()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup("ht.plugrc",
                        { performance = { rtp = { paths = { '~/.dotvim' } } } })
end

-- set mapleader at very beginning of profile
vim.api.nvim_set_var('mapleader', ' ')

-- delay noftify invocations
require'ht.utils'.delay_notify_invocations()

bootstrap_plugin_manager()

-- require 'ht.plugins'

require 'ht.settings'

local mkdir = require 'ht.features.mkdir'
mkdir.register_create_directory_before_save()
