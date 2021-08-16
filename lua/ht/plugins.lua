module('ht.plugins', package.seeall)

local cmd = vim.api.nvim_command

require'ht.plugs'.InitPacker()

local pkr = require'packer'

pkr.init({
  ensure_dependencies = true,
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

pkr.startup(function(use)

end)

