local M = {}

M.core = {
  'lewis6991/gitsigns.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  event = { 'BufReadPost', 'BufNewFile' },
}

M.config = function() -- code to run after plugin loaded
  require'gitsigns'.setup {
    debug_mode = false,
    attach_to_untracked = false,
    -- current_line_blame = true,
    -- current_line_blame_opts = { virt_text = true, delay = 200 },
  }
  require'gitsigns.highlight'.setup_highlights()
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.append_folder_name({ '<leader>', 'v' }, 'vcs')
  mapping.map {
    keys = { '<leader>', 'v', 's' },
    action = function()
      require'gitsigns'.stage_hunk()
    end,
    desc = 'stage-hunk',
  }
  mapping.map {
    keys = { '<leader>', 'v', 'u' },
    action = function()
      require'gitsigns'.undo_stage_hunk()
    end,
    desc = 'undo-stage-hunk',
  }
  mapping.map {
    keys = { '<leader>', 'v', 'm' },
    action = function()
      require'gitsigns'.blame_line { full = true }
    end,
    desc = 'show-commit',
  }
end

return M
-- vim: et sw=2 ts=2 fdm=marker

