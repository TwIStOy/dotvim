local M = { 'akinsho/toggleterm.nvim', version = 'v2.*', event = 'VeryLazy' }

M.init = function() -- code to run before plugin loaded
  vim.api.nvim_set_var('toggleterm_terminal_mapping', '<C-t>')
end

M.opts = {
  open_mapping = '<C-t>',
  hide_numbers = true,
  direction = 'float',
  start_in_insert = true,
  shell = vim.o.shell,
  float_opts = { border = 'double' },
}

return M

-- vim: et sw=2 ts=2 fdm=marker
