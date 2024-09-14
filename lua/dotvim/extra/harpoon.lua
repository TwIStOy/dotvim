---@class dotvim.extra.harpoon
local M = {}

---@return table<string, boolean>
function M.harpooned_items()
  local harpoon = require("harpoon")
  local items = {}
  for _, item in ipairs(harpoon.list().items) do
    items[item.value] = true
  end
  return items
end

return M
