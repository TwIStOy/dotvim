local M = {}

-- Expect node is `field_declaration`
function M.extract_funciton_signature(node)
  local sig = { ret_type = '', func_name = '', args = {}, specifier = {} }

  return sig
end

local function find_parent_impl(node, types)
  if node == nil then
    return nil
  end
  if types[node:type()] then
    return node
  end
  return M.find_parent(node:parent(), types)
end

local function find_child_impl(node, types, pruning)
  if node == nil then
    return nil
  end
  if types[node:type()] then
    return node
  end
  for i = 0, node:child_count() - 1, 1 do
    local c = node:child(i)
    if pruning == nil or pruning[c:type()] then
      local r = find_child_impl(c, types, pruning)
      if r ~= nil then
        return r
      end
    end
  end
  return nil
end

local function find_direct_child_impl(node, types)
  if node == nil then
    return nil
  end
  for i = 0, node:child_count() - 1, 1 do
    local c = node:child(i)
    if types[c:type()] then
      return c
    end
  end
  return nil
end

-- Recursive find parent node
function M.find_parent(node, types)
  if type(types) == 'string' then
    types = { [types] = 1 }
  end

  if type(types) == 'table' then
    if vim.tbl_islist(types) then
      local new_types = {}
      for _, v in ipairs(types) do
        new_types[v] = 1
      end
      types = new_types
    end
  end

  return find_parent_impl(node, types)
end

-- Dfs find child node
function M.find_child(node, types, pruning)
  if type(types) == 'string' then
    types = { [types] = 1 }
  end

  if type(types) == 'table' then
    if vim.tbl_islist(types) then
      local new_types = {}
      for _, v in ipairs(types) do
        new_types[v] = 1
      end
      types = new_types
    end
  end

  return find_child_impl(node, types, pruning)
end

-- find direct child
function M.find_direct_child(node, types)
  if type(types) == 'string' then
    types = { [types] = 1 }
  end

  if type(types) == 'table' then
    if vim.tbl_islist(types) then
      local new_types = {}
      for _, v in ipairs(types) do
        new_types[v] = 1
      end
      types = new_types
    end
  end

  return find_direct_child_impl(node, types)
end

-- Inspect node
function M.inspect_node(node)
  if node == nil then
    return 'nil'
  end
  local ts_utils = require 'nvim-treesitter.ts_utils'

  local start_row, start_col, end_row, end_col = ts_utils.get_node_range(node)

  local res = '' .. node:type()
  res = res .. ' [' .. start_row .. ', ' .. start_col .. ']'
  res = res .. ' [' .. end_row .. ', ' .. end_col .. ']'

  return res
end

return M
