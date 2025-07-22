---@class dotvim.extra.ContextMenuOption
---@field name string|'separator'
---@field rtxt? string
---@field hl? 'ExBlue'|'ExRed'|'ExGreen'
---@field cmd? function
---@field items? dotvim.extra.ContextMenuOption[]

---@alias dotvim.extra.ContextMenuOptions dotvim.extra.ContextMenuOption[]

---@class dotvim.extra.context_menus.utils
local M = {}

---@param opt dotvim.extra.ContextMenuOption
function M.option_should_display(opt)
  if opt.name == "separator" then
    return true
  end
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

---@param list dotvim.extra.ContextMenuOptions
---@param group dotvim.extra.ContextMenuOptions
function M.append_group(list, group)
  if #group > 0 then
    if #list > 0 then
      list[#list + 1] = { name = "separator" }
    end
    vim.list_extend(list, group)
  end
end

return M
