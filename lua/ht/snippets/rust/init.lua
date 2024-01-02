local function import_snippets(module)
  local m = require("ht.snippets.rust.snippets." .. module)
  if m == nil then
    return {}
  end

  if type(m) == "function" then
    return m()
  end
  return m
end

return function()
  local res = {}

  res = vim.list_extend(res, import_snippets("postfix"))
  res = vim.list_extend(res, import_snippets("all"))

  return res
end
