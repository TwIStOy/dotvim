---@class dotvim.utils.string
local M = {}

---@param text string
---@param max_width number
---@param max_lines number?
---@return string[], boolean -- lines, truncated
function M.wrap_text(text, max_width, max_lines)
  local lines = {}
  local line = ""

  for word in text:gmatch("%S+") do
    if #line + #word <= max_width then
      if line == "" then
        line = word
      else
        line = line .. " " .. word
      end
    else
      lines[#lines + 1] = line
      line = word
      if max_lines ~= nil and #lines >= max_lines then
        return lines, true
      end
    end
  end

  lines[#lines + 1] = line

  return lines, false
end

return M
