module('ht.plugs', package.seeall)

local fn = vim.fn
local cmd = vim.cmd

local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim/'

local function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

function InitPacker()
  if not exists(packer_install_path) then
    cmd('!git clone https://github.com/wbthomason/packer.nvim ' ..
            packer_install_path)
  end

  cmd [[pa packer.nvim]]

  local au = require('ht.core.autocmd')

  au.CreateAugroups({
    ht_packer_compile = {
      "BufWritePost", "*/ht/plugins.lua",
      [[echo "Recompile!" | source <afile> | PackerCompile]]
    }
  })
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

