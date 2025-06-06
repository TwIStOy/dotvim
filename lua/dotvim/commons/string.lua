---@module 'dotvim.commons.string'

local M = {}

---Split a string by delimiter
---@param str string
---@param delimiter string
---@param opts? {trimempty?: boolean}
---@return string[]
function M.split(str, delimiter, opts)
  opts = opts or {}
  local result = {}
  local pattern = "([^" .. delimiter .. "]+)"

  for match in str:gmatch(pattern) do
    if not opts.trimempty or match ~= "" then
      table.insert(result, match)
    end
  end

  return result
end

---Join an array of strings with a delimiter
---@param arr string[]
---@param delimiter string
---@return string
function M.join(arr, delimiter)
  return table.concat(arr, delimiter)
end

---Trim whitespace from both ends of a string
---@param str string
---@return string
function M.trim(str)
  return str:match("^%s*(.-)%s*$")
end

---Check if string starts with prefix
---@param str string
---@param prefix string
---@return boolean
function M.starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

---Check if string ends with suffix
---@param str string
---@param suffix string
---@return boolean
function M.ends_with(str, suffix)
  return str:sub(-#suffix) == suffix
end

---Check if string contains substring
---@param str string
---@param substring string
---@return boolean
function M.contains(str, substring)
  return str:find(substring, 1, true) ~= nil
end

return M
