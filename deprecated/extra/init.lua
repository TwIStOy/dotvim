---@class dotvim.extra
local M = {}

---@type dotvim.extra.obsidian
M.obsidian = require("dotvim.extra.obsidian")

---@type dotvim.extra.ui
M.ui = require("dotvim.extra.ui")

---@type dotvim.extra.lsp
M.Lsp = require("dotvim.extra.lsp")

---@type dotvim.extra.context_menu
M.context_menu = require("dotvim.extra.context_menu")

---@type dotvim.extra.search_everywhere
M.search_everywhere = require("dotvim.extra.search-everywhere")

---@type dotvim.extra.harpoon
M.harpoon = require("dotvim.extra.harpoon")

return M
