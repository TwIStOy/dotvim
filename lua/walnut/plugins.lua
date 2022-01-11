module('walnut.plugins', package.seeall)

local fn = vim.fn
local cmd = vim.api.nvim_command
local config = require('ht.plugs.utils').config
local setup = require('ht.plugs.utils').setup

-- packer.nvim
--
-- Install packer.nvim if it's not ready.
--
-- To know whether packer.nvim is installn or not, check this folder exists:
--
--  $DATA/site/pack/packer/start/packer.nvim
--
local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(packer_install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim ' ..
          packer_install_path)
end

cmd('packadd packer.nvim')

--
-- Auto recompile plugins when changes in plugin.lua
--
vim.cmd [[
augroup packer_recompile
  autocmd!
  autocmd BufWritePost */walnut/plugins.lua echom "Recompile!" | source <afile> | PackerCompile
augroup END
]]

local pkr = require('packer')
pkr.init({
  ensure_dependencies = true,
  opt_default = false,
  transitive_opt = false,
  display = {
    auto_clean = false,
    open_fn = function()
      return require('packer.util').float {border = 'single'}
    end
  },
  profile = {
    enable = true,
    threshold = 1,
  }
})

local UsePlugins = require'ht.conf.plugs'.UsePlugins

pkr.startup(UsePlugins)

