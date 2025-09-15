---@module 'dotvim.features'
local M = vim._defer_require("dotvim.features", {
  lsp_methods = ..., ---@module 'dotvim.features.lsp_methods'
})

return M
