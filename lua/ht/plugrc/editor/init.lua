return {
  -- matchup parens
  {
    'andymass/vim-matchup',
    keys = { { '%', nil, mode = { 'n', 'x', 'o' } } },
    init = function() -- code to run before plugin loaded
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 50
      vim.g.matchup_matchparen_deferred_hide_delay = 300
      vim.g.matchup_matchparen_hi_surround_always = 2
      vim.g.matchup_matchparen_offscreen = {
        method = 'popup',
        highlight = 'CurrentWord',
      }
      vim.g.matchup_delim_start_plaintext = 1
      vim.g.matchup_motion_override_Npercent = 0
      vim.g.matchup_motion_cursor_end = 0
      vim.g.matchup_mappings_enabled = 0
    end,
    config = function() -- code to run after plugin loaded
      vim.cmd [[hi! link MatchWord Underlined]]

      vim.cmd [[
        aug Matchup
          au!
          au TermOpen * let [b:matchup_matchparen_enabled, b:matchup_matchparen_fallback] = [0, 0]
        aug END
      ]]

      vim.api.nvim_set_keymap('n', '%', '<Plug>(matchup-%)', { silent = true })
      vim.api.nvim_set_keymap('x', '%', '<Plug>(matchup-%)', { silent = true })
      vim.api.nvim_set_keymap('o', '%', '<Plug>(matchup-%)', { silent = true })
    end,
  },

  -- vim-surround
  {
    'tpope/vim-surround',
    event = 'BufReadPost',
    init = function()
      vim.g.surround_no_mappings = 0
      vim.g.surround_no_insert_mappings = 1
    end,
  },

  -- fast move
  {
    'matze/vim-move',
    keys = {
      { '<C-h>', nil, mode = { 'n', 'v' } },
      { '<C-j>', nil, mode = { 'n', 'v' } },
      { '<C-k>', nil, mode = { 'n', 'v' } },
      { '<C-l>', nil, mode = { 'n', 'v' } },
    },
    init = function()
      vim.g.move_key_modifier = 'C'
      vim.g.move_key_modifier_visualmode = 'C'
    end,
  },

  -- resolve git conflict
  {
    'TwIStOy/conflict-resolve.nvim',
    keys = {
      {
        '<leader>v1',
        '<cmd>call conflict_resolve#ourselves()<CR>',
        desc = 'select-ours',
      },
      {
        '<leader>v2',
        '<cmd>call conflict_resolve#themselves()<CR>',
        desc = 'select-them',
      },
      {
        '<leader>vb',
        '<cmd>call conflict_resolve#both()<CR>',
        desc = 'select-both',
      },
    },
  },

  -- big J
  {
    'osyo-manga/vim-jplus',
    event = 'BufReadPost',
    keys = { { 'J', '<Plug>(jplus)', mode = { 'n', 'v' }, noremap = false } },
  },

  -- tabular
  { 'godlygeek/tabular', cmd = { 'Tabularize' } },
  {
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign' },
    dependencies = { 'godlygeek/tabular' },
    keys = {
      { '<leader>ta', '<cmd>EasyAlign<CR>', desc = 'easy-align' },
      { '<leader>ta', '<cmd>EasyAlign<CR>', mode = 'x', desc = 'easy-align' },
    },
  },
}
