local ts_utils = require 'nvim-treesitter.ts_utils'
local locals = require 'nvim-treesitter.locals'
local utils = require 'nvim-treesitter.utils'

local import = require'ht.utils.import'.import

local M = {}

local copyed_signatures = {}
local valid_qualifiers = { type_qualifier = 1, ref_qualifier = 1, noexcept = 1 }

local function visit_node_as_return_type_part(node)
  if node == nil then
    return {}
  end

  local ntype = node:type()

  if ntype == 'function_declarator' then
    -- end
    return {}
  end

  local res = {}

  if ntype == 'primitive_type' then
    -- builtin type's name
    table.insert(res, vim.treesitter.query.get_node_text(node, 0))
  end

  if ntype == 'pointer_declarator' then
    -- pointer
    table.insert(res, '*')
  end

  if ntype == 'reference_declarator' then
    -- reference
    table.insert(res, vim.treesitter.query.get_node_text(node:child(0), 0))
  end

  local child_count = node:child_count()
  for i = 0, child_count - 1, 1 do
    local c = node:child(i)
    local ctype = c:type()
    if ctype == 'type_identifier' or ctype == 'type_qualifier' then
      table.insert(res, vim.treesitter.query.get_node_text(c, 0))
    else
      table.insert(res, visit_node_as_return_type_part(c))
    end
  end

  return res
end

function M.copy_declare()
  local TS = import 'ht.utils.ts'

  -- clear previous cache
  copyed_signatures = {}

  local node_at_point = ts_utils.get_node_at_cursor()
  local declaration_node = TS.find_parent(node_at_point, {
    'field_declaration',
    'declaration',
  })

  if declaration_node == nil then
    print('No declaration found')
    return
  end

  local function_declarator_node = TS.find_child(declaration_node,
                                                 'function_declarator')

  if function_declarator_node == nil then
    print('No function-declaration in description-stmt found')
    return
  end

  copyed_signatures.return_type = table.concat(vim.tbl_flatten(
                                                   visit_node_as_return_type_part(
                                                       declaration_node)), ' ')

  copyed_signatures.func_name = vim.treesitter.query.get_node_text(
                                    function_declarator_node:field('declarator')[1],
                                    0)

  local class_node = TS.find_parent(declaration_node,
                                    { 'struct_specifier', 'class_specifier' })

  copyed_signatures.class_name = nil
  copyed_signatures.class_template_specialization = true
  copyed_signatures.class_template_parameters = nil
  copyed_signatures.class_template_parameters_name = nil

  if class_node ~= nil then
    -- function is a member function
    local name_node = class_node:field('name')[1]
    copyed_signatures.class_name = vim.treesitter.query.get_node_text(name_node,
                                                                      0)

    if name_node:type() == 'type_identifier' then
      copyed_signatures.class_template_specialization = false
    end
  end

  if class_node ~= nil then
    local template_node = TS.find_parent(class_node, 'template_declaration')
    if template_node ~= nil then
      copyed_signatures.class_template_parameters = {}
      copyed_signatures.class_template_parameters_name = {}
      assert(ts_utils.is_parent(template_node, declaration_node),
             'template-declaration mismatch')
      local template_parameters_list_node = template_node:field('parameters')[1]
      local auto_generate_name_cnt = 0
      for i = 0, template_parameters_list_node:child_count() - 1, 1 do
        local c = template_parameters_list_node:child(i)
        if c:type() == 'type_parameter_declaration' then
          local parameter_name_node = TS.find_direct_child(c, 'type_identifier')
          if parameter_name_node ~= nil then
            table.insert(copyed_signatures.class_template_parameters,
                         vim.treesitter.query.get_node_text(c, 0))
            table.insert(copyed_signatures.class_template_parameters_name,
                         vim.treesitter.query
                             .get_node_text(parameter_name_node, 0))
          else
            local gen_name = 'AutoGen' .. auto_generate_name_cnt
            table.insert(copyed_signatures.class_template_parameters,
                         vim.treesitter.query.get_node_text(c, 0) .. ' ' ..
                             gen_name)
            table.insert(copyed_signatures.class_template_parameters_name,
                         gen_name)
            auto_generate_name_cnt = auto_generate_name_cnt + 1
          end
        elseif c:type() == 'parameter_declaration' then
          local declarator_node = c:field('declarator')[1]
          if declarator_node ~= nil then
            table.insert(copyed_signatures.class_template_parameters,
                         vim.treesitter.query.get_node_text(c, 0))
            table.insert(copyed_signatures.class_template_parameters_name,
                         vim.treesitter.query.get_node_text(declarator_node, 0))
          else
            local gen_name = 'AutoGen' .. auto_generate_name_cnt
            table.insert(copyed_signatures.class_template_parameters,
                         vim.treesitter.query.get_node_text(c, 0) .. ' ' ..
                             gen_name)
            table.insert(copyed_signatures.class_template_parameters_name,
                         gen_name)
            auto_generate_name_cnt = auto_generate_name_cnt + 1
          end
        end
      end
    end
  end

  copyed_signatures.args = {}
  local parameters_node = function_declarator_node:field('parameters')[1]
  for i = 0, parameters_node:child_count() - 1, 1 do
    local c = parameters_node:child(i)
    if c:type() == 'parameter_declaration' then
      table.insert(copyed_signatures.args,
                   vim.treesitter.query.get_node_text(c, 0))
    end
  end

  copyed_signatures.specifier = {}
  for i = 0, function_declarator_node:child_count() - 1, 1 do
    local c = function_declarator_node:child(i)
    if valid_qualifiers[c:type()] then
      table.insert(copyed_signatures.specifier,
                   vim.treesitter.query.get_node_text(c, 0))
    end
  end
end

function M.generate_defination()
  local lines = {}

  if copyed_signatures.class_name then
    if copyed_signatures.class_template_parameters then
      local line = string.format('template<%s>', table.concat(
                                     copyed_signatures.class_template_parameters,
                                     ', '))

      table.insert(lines, line)
    end
  end

  local line = 'auto '
  if copyed_signatures.class_name then
    if not copyed_signatures.class_template_specialization and
        copyed_signatures.class_template_parameters ~= nil and
        copyed_signatures.class_template_parameters_name ~= nil then
      -- no specialization or not a template class
      line = line ..
                 string.format('%s<%s>', copyed_signatures.class_name,
                               table.concat(
                                   copyed_signatures.class_template_parameters_name,
                                   ', ')) .. '::'
    else
      line = line .. copyed_signatures.class_name .. '::'
    end
  end
  line = line .. string.format('%s(%s) %s -> %s {', copyed_signatures.func_name,
                               table.concat(copyed_signatures.args, ', '),
                               table.concat(copyed_signatures.specifier, ' '),
                               copyed_signatures.return_type)
  table.insert(lines, line)
  table.insert(lines, '  // TODO(hawtian): impl')
  table.insert(lines, '}')

  return lines
end

function M.generate_at_cursor()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  if copyed_signatures.func_name ~= nil then
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
