module('ht.plugs.gitsigns', package.seeall)

local nmap = require('ht.keymap.keymap').nmap

function config()
  nmap('<leader>vs', [[<cmd>lua require"gitsigns".stage_hunk()<CR>]],
       {description = 'stage-hunk'})
  nmap('<leader>vu', [[<cmd>lua require"gitsigns".undo_stage_hunk()<CR>]],
       {description = 'undo-stage-hunk'})
end

-- vim: et sw=2 ts=2

