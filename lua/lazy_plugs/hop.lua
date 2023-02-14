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
}
