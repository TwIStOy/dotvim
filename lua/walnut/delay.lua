local cmd = vim.cmd

vim.schedule(function()
  vim.defer_fn(function()
    cmd[[pa numb.nvim]]
  end, 30)

  vim.defer_fn(function()
    cmd[[pa vim-illuminate]]
  end, 300)

  vim.defer_fn(function()
    cmd[[pa vim-surround]]
  end, 500)

  vim.defer_fn(function()
    require('packer').loader('coc.nvim')
  end, 1500)

  vim.defer_fn(function()
    cmd[[pa vim-wakatime]]
  end, 1500)

  vim.defer_fn(function()
    require('packer').loader('nvim-scrollview')
  end, 2000)
end)

