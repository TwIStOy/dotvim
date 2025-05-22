---@module 'dotvim'

local M = vim._defer_require("dotvim", {
  fs = ..., ---@module 'dotvim.fs'
  version = ..., ---@module 'dotvim.version'
  commons = ..., ---@module 'dotvim.commons'
})

return M
