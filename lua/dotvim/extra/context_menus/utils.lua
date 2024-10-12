---@class dotvim.extra.ContextMenuOption
---@field name string|'separator'
---@field rtxt? string
---@field hl? string
---@field cmd? function
---@field items? dotvim.extra.ContextMenuOption[]

---@alias dotvim.extra.ContextMenuOptions dotvim.extra.ContextMenuOption[]

---@class dotvim.extra.context_menus.utils
local M = {}

---@param opt dotvim.extra.ContextMenuOption
function M.option_should_display(opt)
  if opt.cmd ~= nil then
    return true
  end
  if opt.items ~= nil then
    for _, item in ipairs(opt.items) do
      if M.option_should_display(item) then
        return true
      end
    end
    return false
  end
  return false
end

return M
