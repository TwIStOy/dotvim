module('ht.plugs.gitsigns', package.seeall)

local ftmap = require('walnut.keymap').ftmap

function config()
  ftmap('*', 'stage-hunk', 'vs', [[<cmd>lua require"gitsigns".stage_hunk()<CR>]])
  ftmap('*', 'undo-stage-hunk', 'vu', [[<cmd>lua require"gitsigns".undo_stage_hunk()<CR>]])
end

-- vim: et sw=2 ts=2

