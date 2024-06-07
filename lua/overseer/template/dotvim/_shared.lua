---@param search overseer.SearchParams
---@return string[]|nil
local function just_summary(search)
  if vim.fn.executable("just") ~= 1 then
    return nil
  end

  local ret = vim
    .system({ "just", "--summary" }, {
      text = true,
      cwd = search.dir,
    })
    :wait()

  if ret.code ~= 0 then
    return nil
  end

  local stdout = ret.stdout
  if stdout == nil then
    return nil
  end

  local lines = vim.split(stdout, "\n", {
    trimempty = true,
    plain = true,
  })
  return vim
    .iter(lines)
    :map(function(line)
      return vim.split(line, "%s", {
        trimempty = true,
      })
    end)
    :flatten()
    :totable()
end

return {
  just_summary = just_summary,
}
