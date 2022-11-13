local M = {}

M.core = {
  'jedrzejboczar/possession.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  after = 'telescope.nvim',
}

M.config = function() -- code to run after plugin loaded
  require'possession'.setup {
    commands = {
      save = 'SSave',
      load = 'SLoad',
      delete = 'SDelete',
      list = 'SList',
    },
  }
  require('telescope').load_extension('possession')
end

return M

-- vim: et sw=2 ts=2 fdm=marker

