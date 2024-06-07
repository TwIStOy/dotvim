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

---@param search overseer.SearchParams
---@return table?
local function just_dump(search)
  if vim.fn.executable("just") ~= 1 then
    return nil
  end

  local ret = vim
    .system({ "just", "--unstable", "--dump", "--dump-format", "json" }, {
      text = true,
      cwd = search.dir,
    })
    :wait()

  if ret.code ~= 0 then
    return nil
  end

  local stdout = ret.stdout
  local ok, data =
    pcall(vim.json.decode, stdout, { luanil = { object = true } })
  if not ok then
    return nil
  end
  return data
end

return {
  just_summary = just_summary,
  just_dump = just_dump,
}
