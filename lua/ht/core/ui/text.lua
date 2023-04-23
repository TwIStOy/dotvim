local M = {}

---@class UIText
---@field text string text to display
---@field keys table<string, integer> quick-select keys and their index in text
local UIText = {}

---Parse given text. Extract quick-select keys and return a table with
---the following fields:
---  - text: text to display
---  - keys: quick-select keys
---  - action: function to call when item is selected
---@param text string
---@return UIText
function M.parse_ui_text(text)
  -- parse the text, extract the charater after '&' in text
  local keys = {}
  local res_text = ''
  local next_is_key = false
  local skipped_chars = 0
  for i = 1, #text do
    local c = text:sub(i, i)
    if next_is_key then
      keys[c] = i - skipped_chars
      next_is_key = false
      res_text = res_text .. c
      goto continue
    end
    if c == '&' then
      next_is_key = true
      skipped_chars = skipped_chars + 1
    else
      res_text = res_text .. c
    end
    ::continue::
  end
  return { text = res_text, keys = keys }
end

return M
