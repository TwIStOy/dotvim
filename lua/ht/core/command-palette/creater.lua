local CPItem = require("ht.core.command-palette.item")
local Creater = {}

---@param title string|fun():string
---@param action string|fun()
---@param ...table
---@return ht.command_palette.Item
function Creater.quick_item(title, action, ...)
  local item = {
    title = title,
    action = action,
  }
  item = vim.tbl_extend("force", item, ...)
  CPItem.validate(item)
  return CPItem.new(item)
end

return Creater
