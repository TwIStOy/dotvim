---@class dora.lib
local M = {
  plugin = require("dora.lib.plugin"),
  vim = require("dora.lib.vim"),
  ---@class dora.lib.tbl
  tbl = require("dora.lib.tbl"),
  fs = require("dora.lib.fs"),
  ---@class dora.lib.fn
  fn = require("dora.lib.fn"),
  ---@class dora.lib.cache
  cache = require("dora.lib.cache"),
}

M.env = {
  ---@type string?
  gui = (function()
    if vim.g["neovide"] then
      return "neovide"
    end
    if vim.g["fvim_loaded"] then
      return "fvim"
    end
    if vim.g.vscode then
      return "vscode"
    end
    return nil
  end)(),
}

return M
