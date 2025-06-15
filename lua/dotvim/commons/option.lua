---@module "dotvim.commons.option"

local M = {}

---Deep merge two tables recursively.
local function deep_merge_two(t1, t2)
  if type(t1) ~= "table" or type(t2) ~= "table" then
    error("Both arguments must be tables")
  end
  if vim.tbl_isempty(t1) then
    return vim.deepcopy(t2)
  end
  if vim.tbl_isempty(t2) then
    return vim.deepcopy(t1)
  end
  if vim.isarray(t1) and vim.isarray(t2) then
    local res = vim.deepcopy(t1)
    return vim.list_extend(res, t2)
  end
  if vim.isarray(t1) ~= vim.isarray(t2) then
    error(
      "Both tables must be of the same type (array or object) "
        .. vim.inspect { t1 = t1, t2 = t2 }
    )
  end
  local result = {}
  local t1_keys = vim.tbl_keys(t1)
  local t2_keys = vim.tbl_keys(t2)
  for _, key in ipairs(t1_keys) do
    if t2[key] == nil then
      result[key] = vim.deepcopy(t1[key])
    else
      result[key] = deep_merge_two(t1[key], t2[key])
    end
  end
  for _, key in ipairs(t2_keys) do
    if result[key] == nil then
      result[key] = vim.deepcopy(t2[key])
    end
  end
  return result
end

function M.deep_merge(...)
  local args = { ... }
  if #args == 0 then
    return {}
  end
  if #args == 1 then
    return vim.deepcopy(args[1])
  end
  local result = vim.deepcopy(args[1])
  for i = 2, #args do
    result = deep_merge_two(result, args[i])
  end
  return result
end

return M
