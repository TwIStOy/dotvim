return {
  -- motion
  Use {
    'phaazon/hop.nvim',
    lazy = {
      cmd = {
        'HopWord',
        'HopPattern',
        'HopChar1',
        'HopChar2',
        'HopLine',
        'HopLineStart',
      },
      opts = { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 },
    },
    functions = {
      FuncSpec('Jump to word', 'HopWord',
               { keys = { 's', ',,' }, desc = 'jump-to-word' }),
      FuncSpec('Jump to line', 'HopLine', { keys = ',l', desc = 'jump-to-line' }),
    },
  },

  -- motion in line with f/F
  Use {
    'jinh0/eyeliner.nvim',
    lazy = {
      cmd = { 'EyelinerEnable', 'EyelinerDisable', 'EyelinerToggle' },
      keys = {
        { 'f', nil, mode = { 'n' } },
        { 'F', nil, mode = { 'n' } },
        { 't', nil, mode = { 'n' } },
        { 'T', nil, mode = { 'n' } },
      },
      opts = { highlight_on_key = true, dim = true },
    },
    functions = {
      FuncSpec('Enable Eyeliner', 'EyelinerEnable'),
      FuncSpec('Disable Eyeliner', 'EyelinerDisable'),
      FuncSpec('Toggle Eyeliner', 'EyelinerToggle'),
    },
  },
}
