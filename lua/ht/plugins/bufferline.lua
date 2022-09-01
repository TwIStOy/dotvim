local M = {}

M.requires = function() -- return required packages
end

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
  local opt = { silent = true, noremap = true }
  return {
    default = {
      ['*'] = {
        { 'n', '<M-,>', '<cmd>BufferLineCyclePrev<CR>', opt },
        { 'n', '<M-.>', '<cmd>BufferLineCycleNext<CR>', opt },
        { 'n', '<M-<>', '<cmd>BufferLineMovePrev<CR>', opt },
        { 'n', '<M->>', '<cmd>BufferLineMoveNext<CR>', opt },
      },
    },
  }
end

return M
-- vim: et sw=2 ts=2 fdm=marker

