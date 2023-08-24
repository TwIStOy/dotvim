---@param match string|Array<string>
---@param template string
local function replace_all(match, template)
  if type(match) == "string" then
    local str = template:gsub("%%s", match)
    local lines = {}
    for s in str:gmatch("[^\r\n]+") do
      table.insert(lines, s)
    end
    if #lines == 1 then
      return str
    else
      return lines
    end
  else
    -- split template by "%s"
    local parts = vim.split(template, "%s", {
      plain = true,
      trimempty = false,
    })

    -- put match between parts
    local res = {}
    for i = 1, #parts - 1, 1 do
      local lines = vim.deepcopy(match)
      if i == 1 then
        lines[1] = parts[i] .. lines[1]
      end
      lines[#lines] = lines[#lines] .. parts[i + 1]
      vim.list_extend(res, lines)
    end
    return res
  end
end

return {
  replace_all = replace_all,
}
