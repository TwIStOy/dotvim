---@param match string|string[]
---@param template string
local function replace_all(match, template)
  ---@type string
  local match_str = {}
  if type(match) == "table" then
    match_str = table.concat(match, "\n")
  else
    match_str = match
  end

  local ret_str = template:gsub("%%s", match_str)
  local ret = vim.split(ret_str, "\n", {
    trimempty = false,
  })

  return ret
end

return {
  replace_all = replace_all,
}
