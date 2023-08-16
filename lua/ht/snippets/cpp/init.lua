local function import_snippets(module)
  local m = require("ht.snippets.cpp.snippets." .. module)
  if m ~= nil then
    return m
  end
  return {}
end

return function()
  local res = {}

  res = vim.list_extend(res, import_snippets("func"))
  res = vim.list_extend(res, import_snippets("cpo"))
  res = vim.list_extend(res, import_snippets("type"))
  res = vim.list_extend(res, import_snippets("macro"))
  res = vim.list_extend(res, import_snippets("postfix"))
  res = vim.list_extend(res, import_snippets("others"))
  res = vim.list_extend(res, import_snippets("statements"))

  return res
end
