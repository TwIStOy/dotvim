local ts_utils = require 'nvim-treesitter.ts_utils'
local import = require'ht.utils.import'.import
local tbl_utils = require 'ht.utils.table'
local middleclass = require 'middleclass'
local TS = import 'ht.utils.ts'

local M = {}

local function get_node_text(node)
  return vim.treesitter.query.get_node_text(node, 0)
end

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

  if ntype == 'qualified_identifier' then
    local scope_node = node:field('scope')[1]
    local scope = ''
    if scope_node ~= nil then
      scope = get_node_text(scope_node)
    end
    table.insert(res, string.format('%s::', scope))
  end

  if ntype == 'primitive_type' then
    -- builtin type's name
    table.insert(res, get_node_text(node))
  end

  if ntype == 'pointer_declarator' then
    -- pointer
    table.insert(res, '*')
  end

  if ntype == 'reference_declarator' then
    -- reference
    table.insert(res, get_node_text(node:child(0)))
  end

  local child_count = node:child_count()
  for i = 0, child_count - 1, 1 do
    local c = node:child(i)
    local ctype = c:type()
    if ctype == 'type_identifier' or ctype == 'type_qualifier' then
      table.insert(res, get_node_text(c))
    else
      table.insert(res, visit_node_as_return_type_part(c))
    end
  end

  return res
end

local function get_return_type_info(node)
  local type_node = node:field('type')[1]
  if type_node == nil then
    return ''
  end

  local prefix = get_node_text(type_node)

  local declarator = node:field('declarator')[1]

  return prefix ..
             table.concat(
                 vim.tbl_flatten(visit_node_as_return_type_part(declarator)),
                 ' ')
end

local function get_template_info(template_node)
  local template_sig = {
    parameters = {},
    parameter_names = {},
    is_specialization = false,
  }

  local template_parameters_list_node = template_node:field('parameters')[1]
  local auto_generate_name_cnt = 0
  for i = 0, template_parameters_list_node:child_count() - 1, 1 do
    local c = template_parameters_list_node:child(i)
    if c:type() == 'type_parameter_declaration' then
      local parameter_name_node = TS.find_direct_child(c, 'type_identifier')
      if parameter_name_node ~= nil then
        table.insert(template_sig.parameters, get_node_text(c))
        table.insert(template_sig.parameter_names,
                     get_node_text(parameter_name_node))
      else
        local gen_name = 'AutoGen' .. auto_generate_name_cnt
        table.insert(template_sig.parameters,
                     get_node_text(c) .. ' ' .. gen_name)
        table.insert(template_sig.parameter_names, gen_name)
        auto_generate_name_cnt = auto_generate_name_cnt + 1
      end
    elseif c:type() == 'parameter_declaration' then
      local declarator_node = c:field('declarator')[1]
      if declarator_node ~= nil then
        table.insert(template_sig.parameters, get_node_text(c))
        table.insert(template_sig.parameter_names,
                     get_node_text(declarator_node))
      else
        local gen_name = 'AutoGen' .. auto_generate_name_cnt
        table.insert(template_sig.parameters,
                     get_node_text(c) .. ' ' .. gen_name)
        table.insert(template_sig.parameter_names, gen_name)
        auto_generate_name_cnt = auto_generate_name_cnt + 1
      end
    end
  end

  return template_sig
end

local function get_class_info(class_node)
  local class_sig = { name = '', template = nil }

  local name_node = class_node:field('name')[1]
  class_sig.name = get_node_text(name_node)

  local template_node = TS.find_parent(class_node, 'template_declaration')
  if template_node ~= nil then
    local template_sig = get_template_info(template_node)
    if name_node:type() == 'type_identifier' then
      template_sig.is_specialization = false
    else
      template_sig.is_specialization = true
    end
    class_sig.template = template_sig
  end

  return class_sig
end

--- Parse and calculate function's signature from given node
---@param node tsnode
---@return boolean, table | string, function's signature
function M.extract_function_signature_from_node(node)
  local sig = {
    return_type = '',
    name = '',
    class = nil,
    parameters = {},
    specifiers = {},
    template = nil,
  }

  local declaration_node = TS.find_parent(node, {
    'field_declaration',
    'declaration',
    'function_definition',
  })

  if declaration_node == nil then
    return false, 'No declaration found'
  end

  local function_declarator_node
  if node:type() == 'function_declarator' then
    function_declarator_node = node
  else
    function_declarator_node = TS.find_child(declaration_node,
                                             'function_declarator')
  end

  if function_declarator_node == nil then
    return false, 'No function-declaration in description-stmt found'
  end

  sig.return_type = get_return_type_info(declaration_node)

  sig.name = get_node_text(function_declarator_node:field('declarator')[1])

  if declaration_node:parent():type() == 'template_declaration' then
    local template_node = declaration_node:parent()
    local parameters_node = template_node:field('parameters')[1]
    -- template function
    sig.template = {}
    for i = 0, parameters_node:child_count() - 1, 1 do
      local c = parameters_node:child(i)
      if c:type() == 'type_parameter_declaration' then
        table.insert(sig.template, get_node_text(c))
      end
    end
  end

  local parameters_node = function_declarator_node:field('parameters')[1]
  for i = 0, parameters_node:child_count() - 1, 1 do
    local c = parameters_node:child(i)
    if c:type() == 'parameter_declaration' then
      table.insert(sig.parameters, get_node_text(c))
    end
  end

  local valid_specifiers = { type_qualifier = 1, ref_qualifier = 1,
                             noexcept = 1 }
  for i = 0, function_declarator_node:child_count() - 1, 1 do
    local c = function_declarator_node:child(i)
    -- valid specifiers
    --   const
    --   &
    --   noexcept
    if valid_specifiers[c:type()] then
      table.insert(sig.specifiers, get_node_text(c))
    end
  end

  local class_node = TS.find_parent(declaration_node,
                                    { 'struct_specifier', 'class_specifier' })
  -- check if it's class method
  if class_node ~= nil then
    -- function is a member function
    sig.class = get_class_info(class_node)
  end

  return true, sig
end

function M.function_signature_to_code_lines(sig)
  local lines = {}

  if sig.class ~= nil then
    if sig.class.template ~= nil then
      local line = string.format('template<%s>', table.concat(
                                     sig.class.template.parameters, ', '))

      table.insert(lines, line)
    end
  end

  local line = 'auto '
  if sig.class ~= nil then
    if sig.class.template ~= nil and not sig.class.template.is_specialization then
      -- no specialization or not a template class
      line = line .. string.format('%s<%s>', sig.class.name, table.concat(
                                       sig.class.template.parameter_names, ', ')) ..
                 '::'
    else
      line = line .. sig.class.name .. '::'
    end
  end

  if sig.template ~= nil then
    table.insert(lines, string.format('template<%s>',
                                      table.concat(sig.template, ', ')))
  end

  line = line ..
             string.format('%s(%s) %s -> %s {', sig.name,
                           table.concat(sig.parameters, ', '),
                           table.concat(sig.specifiers, ' '), sig.return_type)
  table.insert(lines, line)
  table.insert(lines, '  // TODO(hawtian): impl')
  table.insert(lines, '}')

  return lines
end

return M

