module('ht.conf.delay', package.seeall)

local cmd = vim.cmd

local function _load(name, ms)
  vim.defer_fn(function()
    if type(name) == 'string' then
      cmd([[pa ]] .. name)
    end
    if type(name) == 'table' then
      for _, name in ipairs(name) do
        cmd([[pa ]] .. name)
      end
    end
  end, ms)
end

function DelayLoader()
  vim.schedule(function()
    _load('numb.nvim', 30)
    _load('vim-illuminate', 300)
    _load('vim-surround', 500)

    vim.defer_fn(function()
      require('packer').loader('vim-textobj-user')
    end, 1000)

    vim.defer_fn(function()
      require('packer').loader('coc.nvim')
    end, 1500)

    vim.defer_fn(function()
      require('packer').loader('nvim-scrollview')
    end, 2000)
  end)
end

-- vim: et sw=2 ts=2 fdm=marker

