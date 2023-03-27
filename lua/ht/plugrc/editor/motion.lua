return {
  -- motion
  {
    'phaazon/hop.nvim',
    cmd = {
      'HopWord',
      'HopPattern',
      'HopChar1',
      'HopChar2',
      'HopLine',
      'HopLineStart',
    },
    opts = { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 },
    keys = {
      { 's', '<cmd>HopWord<CR>', desc = 'jump-word' },
      { ',,', '<cmd>HopWord<CR>', desc = 'jump-word' },
      { ',l', '<cmd>HopLine<CR>', desc = 'jump-line' },
    },
  },

  -- motion in line with f/F
  {
    'jinh0/eyeliner.nvim',
    cmd = { 'EyelinerEnable', 'EyelinerDisable', 'EyelinerToggle' },
    keys = {
      { 'f', nil, mode = { 'n' } },
      { 'F', nil, mode = { 'n' } },
      { 't', nil, mode = { 'n' } },
      { 'T', nil, mode = { 'n' } },
    },
    opts = { highlight_on_key = true, dim = true },
  },
}
