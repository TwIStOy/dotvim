local M = {}

M.core = {
  'akinsho/toggleterm.nvim',
  tag = 'v2.*',
  keys = { '<C-t>' },
  module = { 'toggleterm' },
}

M.setup = function() -- code to run before plugin loaded
  vim.api.nvim_set_var('toggleterm_terminal_mapping', '<C-t>')
end

M.config = function() -- code to run after plugin loaded
  require'toggleterm'.setup {
    open_mapping = '<C-t>',
    hide_numbers = true,
    direction = 'float',
    start_in_insert = true,
    shell = vim.o.shell,
    float_opts = { border = 'double' },
  }
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

