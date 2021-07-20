module('ht.plugs.toggleterm', package.seeall)

function setup() vim.api.nvim_set_var('toggleterm_terminal_mapping', '<C-t>') end

function config()
  require'toggleterm'.setup {
    open_mapping = '<C-t>',
    hide_numbers = true,
    direction = 'float',
    start_in_insert = true,
    shell = vim.o.shell,
    float_opts = {border = 'double'}
  }
end

-- vim: et sw=2 ts=2

