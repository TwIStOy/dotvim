---@class dotvim.extra.ui.context_menu.MenuText
---@field raw_text string
---@field text string
---@field keys table<string, boolean>
---@field parts table<number, table<'key'|'normal', string>>
local MenuText = {}

---Create a new `Text` object from string.
---@param text any
---@return dotvim.extra.ui.context_menu.MenuText
local function from_str(text)
  local res = { raw_text = text, text = "", parts = {}, keys = {} }

  local next_is_key = false
  local previous_part = ""
  for i = 1, #text do
    local c = text:sub(i, i)
    if next_is_key then
      res.keys[c] = true
      if #previous_part > 0 then
        table.insert(res.parts, { normal = previous_part })
      end
      previous_part = ""
      table.insert(res.parts, { key = c })
      next_is_key = false
      res.text = res.text .. c
      goto continue
    end
    if c == "&" then
      next_is_key = true
    else
      previous_part = previous_part .. c
      res.text = res.text .. c
    end
    ::continue::
  end
  if #previous_part > 0 then
    table.insert(res.parts, { normal = previous_part })
  end

  setmetatable(res, { __index = MenuText })

  return res
end

---@param disabled boolean
---@param line NuiLine
---@return NuiLine
function MenuText:into_nui_line(disabled, line)
  local hl = function(group)
    if disabled then
      return "Comment"
    end
    return group
  end
  for _, part in ipairs(self.parts) do
    if part.key ~= nil then
      line:append(part.key, hl("@keyword"))
    else
      line:append(part.normal, hl("Normal"))
    end
  end
  return line
end

function MenuText:length()
  return #self.text
end

return from_str
