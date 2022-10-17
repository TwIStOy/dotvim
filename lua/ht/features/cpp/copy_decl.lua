local ts_utils = require 'nvim-treesitter.ts_utils'

local import = require'ht.utils.import'.import
local function_sig = import 'ht.features.cpp.function_sig'
local TS = import 'ht.utils.ts'
local selection = import 'ht.features.selection'

local M = {}

local copyed_signatures = {}

function M.copy_declare()
  -- clear previous cache
  copyed_signatures = {}

  local node_at_point = ts_utils.get_node_at_cursor()

  local ok, sig = function_sig.extract_function_signature_from_node(
                      node_at_point)
  if ok then
    table.insert(copyed_signatures, sig)
  else
    print(sig)
  end
end

function M.copy_declare_range(start_row, end_row)
  copyed_signatures = {}

  local nodes = TS.get_nodes_in_range(0, start_row, 1, end_row, 2147483647)
  for _, node in ipairs(nodes) do
    local ok, sig = function_sig.extract_function_signature_from_node(node)
    if ok then
      table.insert(copyed_signatures, sig)
    end
  end

  print(string.format('Copyed %d functions', #copyed_signatures))
end

function M.copy_declare_from_selection()
  local sr, _, er, _ = selection.visual_selection_range()
  M.copy_declare_range(sr - 1, er - 1)
end

function M.generate_defination(sig)
  return function_sig.function_signature_to_code_lines(sig)
end

function M.generate_at_cursor()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = {}

  for _, sig in ipairs(copyed_signatures) do
    if sig.name ~= nil then
      table.insert(lines, M.generate_defination(sig))
    end
  end

  lines = vim.tbl_flatten(lines)
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, true, lines)
end

function M.test()
  M.copy_declare()
  print(vim.inspect(copyed_signatures))
  print(table.concat(M.generate_defination(copyed_signatures[1]), '\n'))
end

function M.test_range()
  local sr, sc, er, ec = selection.visual_selection_range()
  print(sr, sc, er, ec)

  M.copy_declare_range(sr - 1, er - 1)
  print(vim.inspect(copyed_signatures))

  local lines = {}
  for _, sig in ipairs(copyed_signatures) do
    if sig.name ~= nil then
      table.insert(lines, M.generate_defination(sig))
    end
  end
  lines = vim.tbl_flatten(lines)
  print(table.concat(lines, '\n'))
end

return M
