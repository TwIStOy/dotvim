local ts_utils = require 'nvim-treesitter.ts_utils'

local import = require'ht.utils.import'.import
local function_sig = import 'ht.features.cpp.function_sig'

local M = {}

local copyed_signatures = {}

function M.copy_declare()
  -- clear previous cache
  copyed_signatures = {}

  local node_at_point = ts_utils.get_node_at_cursor()

  local ok, sig = function_sig.extract_function_signature_from_node(
                      node_at_point)
  if ok then
    copyed_signatures = sig
  else
    print(sig)
  end
end

function M.generate_defination()
  local lines = {}

  if copyed_signatures.class ~= nil then
    if copyed_signatures.class.template ~= nil then
      local line = string.format('template<%s>', table.concat(
                                     copyed_signatures.class.template.parameters,
                                     ', '))

      table.insert(lines, line)
    end
  end

  local line = 'auto '
  if copyed_signatures.class ~= nil then
    if copyed_signatures.class.template ~= nil and
        not copyed_signatures.class.template.is_specialization then
      -- no specialization or not a template class
      line = line ..
                 string.format('%s<%s>', copyed_signatures.class.name,
                               table.concat(
                                   copyed_signatures.class.template
                                       .parameter_names, ', ')) .. '::'
    else
      line = line .. copyed_signatures.class.name .. '::'
    end
  end

  if copyed_signatures.template ~= nil then
    table.insert(lines, string.format('template<%s>', table.concat(
                                          copyed_signatures.template, ', ')))
  end

  line = line .. string.format('%s(%s) %s -> %s {', copyed_signatures.name,
                               table.concat(copyed_signatures.parameters, ', '),
                               table.concat(copyed_signatures.specifiers, ' '),
                               copyed_signatures.return_type)
  table.insert(lines, line)
  table.insert(lines, '  // TODO(hawtian): impl')
  table.insert(lines, '}')

  return lines
end

function M.generate_at_cursor()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  if copyed_signatures.name ~= nil then
    local lines = M.generate_defination()
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, true, lines)
  else
    print('Must Copy First!')
  end
end

function M.test()
  M.copy_declare()
  print(vim.inspect(copyed_signatures))
  print(table.concat(M.generate_defination(), '\n'))
end

return M
