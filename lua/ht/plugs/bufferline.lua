module('ht.plugs.bufferline', package.seeall)

function config()
  require('bufferline').setup {
    options = {
      view = 'multiwindow',
      separator_style = 'slant',
      numbers = function(opts)
        return string.format('%s·%s', opts.raise(opts.id),
                             opts.lower(opts.ordinal))
      end
    }
  }
  vim.api.nvim_set_keymap('n', '<M-,>', ':BufferLineCyclePrev<CR>',
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<M-.>', ':BufferLineCycleNext<CR>',
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<M-<>', ':BufferLineMovePrev<CR>',
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<M->>', ':BufferLineMoveNext<CR>',
                          {silent = true, noremap = true})
end

-- vim: et sw=2 ts=2

