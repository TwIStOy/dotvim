---@class dotvim.extra.ui.context_menu
local M = {}

---@type fun(any):dotvim.extra.ui.context_menu.MenuItem?
M.MenuItem = require("dotvim.extra.ui.context_menu.item")

---@type fun(text):dotvim.extra.ui.context_menu.MenuText
M.MenuText = require("dotvim.extra.ui.context_menu.text")

return M
