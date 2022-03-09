module('ht.plugs.neogen', package.seeall)

function config()
  local neogen = require 'neogen'

  neogen.setup {}

  local nmap = require'ht.keymap.keymap'.nmap

  nmap('<leader>nf', [[<cmd>lua require('neogen').generate()<CR>]],
       { description = 'Generate Document' })
end

-- vim: et sw=2 ts=2

