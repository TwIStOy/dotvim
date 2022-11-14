local M = {}

M.core = { 'zbirenbaum/copilot.lua', event = 'VimEnter' }

M.config = function() -- code to run after plugin loaded
  vim.defer_fn(function()
    require'copilot'.setup()
  end, 100)
end

return M

-- vim: et sw=2 ts=2 fdm=marker

