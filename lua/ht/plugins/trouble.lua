local M = {}

M.core = { 'folke/trouble.nvim', requires = { 'folke/lsp-colors.nvim' } }

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require'trouble'.setup { use_diagnostic_signs = true }
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping:append_folder_name('*', { '<leader>', 'x' }, 'x-ray')

  mapping:map('*', {
    keys = { '<leader>', 'x', 'x' },
    action = '<cmd>TroubleToggle<CR>',
    desc = 'toggle-trouble-window',
  })
  mapping:map('*', {
    keys = { '<leader>', 'x', 'w' },
    action = '<cmd>TroubleToggle workspace_diagnostics<CR>',
    desc = 'workspace-diagnostics',
  })
  mapping:map('*', {
    keys = { '<leader>', 'x', 'd' },
    action = '<cmd>TroubleToggle document_diagnostics<CR>',
    desc = 'document-diagnostics',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

