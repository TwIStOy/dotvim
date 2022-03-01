module('ht.plugs', package.seeall)

local fn = vim.fn
local cmd = vim.cmd
local cv = require 'ht.core.vim'

local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim/'

function InitPacker()
  if not vim.loop.fs_stat(vim.fn.glob(packer_install_path)) then
    os.execute('git clone https://github.com/wbthomason/packer.nvim ' ..
                   packer_install_path)
  end

  cmd [[pa packer.nvim]]

  cv.event:on('BufWritePost', "*/ht/plugins.lua",
              [[echo "Recompile!" | source <afile> | PackerCompile]],
              "Recompile plugins.lua")
  cv.event:on('BufWritePost', "*/ht/conf/plugs.lua",
              [[echo "Recompile!" | source <afile> | PackerCompile]],
              "Recompile plugins.lua")
end

function IsLoaded(name)
  return packer_plugins and packer_plugins[name] and packer_plugins[name].loaded
end

function Config(plug)
  return ([[require('ht.plugs.%s').config()]]):format(plug)
end

function Setup(plug)
  return ([[require('ht.plugs.%s').setup()]]):format(plug)
end

-- vim: et sw=2 ts=2

