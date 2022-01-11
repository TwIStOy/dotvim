module('ht.plugs.gitsigns', package.seeall)

local nmap = require('ht.keymap.keymap').nmap

function config()
  nmap('<leader>vs', [[<cmd>lua require"gitsigns".stage_hunk()<CR>]],
       {description = 'stage-hunk'})
  nmap('<leader>vu', [[<cmd>lua require"gitsigns".undo_stage_hunk()<CR>]],
       {description = 'undo-stage-hunk'})
  nmap('<leader>vm', [[<cmd>lua require"gitsigns".blame_line{full=true}<CR>]],
       {description = 'show-commit'})
  require'gitsigns'.setup {
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      delay = 200,
    },
  }
  require'gitsigns.manager'.setup_signs_and_highlights()
end

-- vim: et sw=2 ts=2

