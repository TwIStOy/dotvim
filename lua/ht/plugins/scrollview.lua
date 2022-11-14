local M = {}

M.core = { 'dstein64/nvim-scrollview', opt = true, events = { 'BufReadPost' } }

--[[
M.setup = function() -- code to run before plugin loaded
  vim.g.scrollview_on_startup = 1
  vim.g.scrollview_current_only = 1
  vim.g.scrollview_auto_workarounds = 1
  vim.g.scrollview_nvim_14040_workaround = 1

  vim.defer_fn(function()
    require'packer'.loader 'nvim-scrollview'
  end, 2000)
end
--]]

M.config = function()
  require'scrollview'.setup({})
end

return M

-- vim: et sw=2 ts=2 fdm=marker

