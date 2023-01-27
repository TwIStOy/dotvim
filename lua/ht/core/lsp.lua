local M = {}

M.callbacks = {}

M.add_attach_callback = function(callback)
  vim.list_extend(M.callbacks, { callback })
end

return M
