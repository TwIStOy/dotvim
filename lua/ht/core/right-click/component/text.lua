---@class ht.right_click.MenuText.Fragment
---@field key string?
---@field normal string?

---@class ht.right_click.MenuText
---@field private _raw_text string
---@field private _text string
---@field private _keys string[]
---@field private _parts ht.right_click.MenuText.Fragment[]
local MenuText = {}

---Create a new `Text` object from string.
---@param text string
---@return ht.right_click.MenuText
function MenuText.new(text)
  ---@type ht.right_click.MenuText
  local res = { _raw_text = text, _text = "", _parts = {}, _keys = {} }

  local next_is_key = false
  local previous_part = ""
  for i = 1, #text do
    local c = text:sub(i, i)
    if next_is_key then
      res._keys[#res._keys + 1] = c
      if #previous_part > 0 then
        res._parts[#res._parts + 1] = { normal = previous_part }
      end
      previous_part = ""
      res._parts[#res._parts + 1] = { key = c }
      next_is_key = false
      res._text = res._text .. c
      goto continue
    end
    if c == "&" then
      next_is_key = true
    else
      previous_part = previous_part .. c
      res._text = res._text .. c
    end
    ::continue::
  end
  if #previous_part > 0 then
    res._parts[#res._parts + 1] = { normal = previous_part }
  end
  setmetatable(res, { __index = MenuText })
  return res
end

--FIXME(hawtian):
-- right-click default highlight
-- key: @variable.builtin
-- normal: nil

---@return NuiLine
function MenuText:as_nui_line()
  local NuiLine = require("nui.line")
  local line = NuiLine()
  for _, part in ipairs(self._parts) do
    if part.key ~= nil then
      line:append(part.key, "@variable.builtin")
    else
      line:append(part.normal, nil)
    end
  end
  return line
end

---@return number
function MenuText:length()
  return #self._text
end

---@return string[]
function MenuText:keys()
  return self._keys
end

function MenuText:is_separator()
  return self._raw_text == "---"
end

return MenuText
