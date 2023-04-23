local M = {}

---@class MenuText
---@field text string
local MenuText = {}

---Create a new `Text` object from string.
---@param text any
---@return MenuText
function M.from_str(text)
  local res = { text = text }
  setmetatable(res, { __index = MenuText })
  return res
end

function MenuText:

return M
