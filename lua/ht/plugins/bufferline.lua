local M = {}

M.core = {
  'akinsho/bufferline.nvim',
  tag = 'v2.*',
  requires = { 'kyazdani42/nvim-web-devicons' },
}

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require('bufferline').setup {
    options = {
      view = 'multiwindow',
      separator_style = 'thin',
      numbers = function(opts)
        return string.format('%s¬∑%s', opts.raise(opts.id),
                             opts.lower(opts.ordinal))
      end,
      diagnostics = 'nvim_lsp',
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          highlight = 'Directory',
        },
      },
    },
  }
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'
  mapping:map('*',
              { keys = { '<M-,>' }, action = '<cmd>BufferLineCyclePrev<CR>' })
  mapping:map('*',
              { keys = { '<M-.>' }, action = '<cmd>BufferLineCycleNext<CR>' })
  mapping:map('*',
              { keys = { '<M-<>' }, action = '<cmd>BufferLineMovePrev<CR>' })
  mapping:map('*',
              { keys = { '<M->>' }, action = '<cmd>BufferLineMoveNext<CR>' })
end

return M
-- vim: et sw=2 ts=2 fdm=marker

