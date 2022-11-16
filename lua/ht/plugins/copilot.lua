local M = {}

M.core = { 'zbirenbaum/copilot.lua', event = 'BufReadPost' }

M.config = function() -- code to run after plugin loaded
  vim.schedule(function()
    require'copilot'.setup()
  end)
end

return M

-- vim: et sw=2 ts=2 fdm=marker

