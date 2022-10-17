local parsers = require "nvim-treesitter.parsers"
local TSRange = require'nvim-treesitter.tsrange'.TSRange
local ts_utils = require 'nvim-treesitter.ts_utils'
local import = require'ht.utils.import'.import
local selection = import 'ht.features.selection'

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

  local start_row, start_col, end_row, end_col = ts_utils.get_node_range(node)

  local res = '' .. node:type()
  res = res .. ' [' .. start_row .. ', ' .. start_col .. ']'
  res = res .. ' [' .. end_row .. ', ' .. end_col .. ']'

  return res
end

local function get_nodes_in_range_impl(root, start_row, start_col, end_row,
                                       end_col)
  if root == nil then
    return {}
  end
  local n_start_row, n_start_col, n_end_row, n_end_col = root:range()

  if selection.compare_pos(end_row, end_col, n_start_row, n_start_col) < 0 then
    return {}
  end

  if selection.compare_pos(n_end_row, n_end_col, start_row, start_col) < 0 then
    return {}
  end

  if selection.compare_pos(start_row, start_col, n_start_row, n_start_col) <= 0 and
      selection.compare_pos(end_row, end_col, n_end_row, n_end_col) >= 0 then
    return { root }
  end

  local res = {}

  for i = 0, root:child_count() - 1, 1 do
    local c = root:child(i)
    table.insert(res, get_nodes_in_range_impl(c, start_row, start_col, end_row,
                                              end_col))
  end

  return vim.tbl_flatten(res)
end

function M.get_nodes_in_range(winnr, start_row, start_col, end_row, end_col)
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  local root_lang_tree = parsers.get_parser(bufnr)
  local root = ts_utils.get_root_for_position(start_row, start_col,
                                              root_lang_tree)

  local nodes = get_nodes_in_range_impl(root, start_row, start_col, end_row,
                                        end_col)
  return nodes
end

return M
