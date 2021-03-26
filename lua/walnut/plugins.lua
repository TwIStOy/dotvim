module('walnut.plugins', package.seeall)

local fn = vim.fn
local cmd = vim.api.nvim_command

local packer_install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  cmd('packadd packer.nvim')
end

-- Auto recompile plugins when changes in plugin.lua
cmd('autocmd BufWritePost */walnut/plugins.lua PackerCompile')

local pkr = require('packer')
pkr.init({
  display = {
    auto_clean = false
  }
})

pkr.startup(function(use)
  use { 'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'} }

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime'
  }

  use {
    'mhinz/vim-startify',
    cmd = {'Startify'},
    config = function() require('walnut.config.startify') end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require('walnut.config.nvim_tree') end,
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use {
    'liuchengxu/vim-which-key',
    cmd = ['WhichKey', 'WhichKey!'],
    config = function() require('walnut.config.whichkey') end
  }

  use 'skywind3000/vim-quickui'
end)
