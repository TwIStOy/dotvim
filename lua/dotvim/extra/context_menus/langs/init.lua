---@class dotvim.extra.context_menus.langs
local M = {}

---@type dotvim.extra.context_menus.utils
local Utils = require("dotvim.extra.context_menus.utils")

---@param buf number
---@return dotvim.extra.ContextMenuOption
function M.build_langs_group(buf)
  ---@type dotvim.extra.ContextMenuOption
  local ret = {
    name = "󱩽 Languages",
    hl = "ExBlue",
    items = {},
  }

  local lang_modules = {
    require("dotvim.extra.context_menus.langs.cpp"),
    require("dotvim.extra.context_menus.langs.rust"),
  }

  for _, lang_module in ipairs(lang_modules) do
    Utils.append_group(ret.items, lang_module.build_context_menu_options(buf))
  end

  return ret
end

return M
