local M = { "ziontee113/SelectEase", lazy = true, enabled = false }

local c_query = [[
    ;; query
    ((string_literal) @cap)
    ((system_lib_string) @cap)

    ; Identifiers
    ((identifier) @cap)
    ((struct_specifier) @cap)
    ((type_identifier) @cap)
    ((field_identifier) @cap)
    ((number_literal) @cap)
    ((unary_expression) @cap)
    ((pointer_declarator) @cap)

    ; Types
    ((primitive_type) @cap)

    ; Expressions
    (assignment_expression
     right: (_) @cap)
]]

local cpp_query = [[
    ;; query

    ; Identifiers
    ((namespace_identifier) @cap)
]] .. c_query

local go_query = [[
    ;; query
    ((selector_expression) @cap) ; Method call
    ((field_identifier) @cap) ; Method names in interface

    ; Identifiers
    ((identifier) @cap)
    ((expression_list) @cap) ; pseudo Identifier
    ((int_literal) @cap)
    ((interpreted_string_literal) @cap)

    ; Types
    ((type_identifier) @cap)
    ((pointer_type) @cap)
    ((slice_type) @cap)

    ; Keywords
    ((true) @cap)
    ((false) @cap)
    ((nil) @cap)
]]

local rust_query = [[
    ;; query
    ((boolean_literal) @cap)
    ((string_literal) @cap)

    ; Identifiers
    ((identifier) @cap)
    ((field_identifier) @cap)
    ((field_expression) @cap)
    ((scoped_identifier) @cap)
    ((unit_expression) @cap)

    ; Types
    ((reference_type) @cap)
    ((primitive_type) @cap)
    ((type_identifier) @cap)
    ((generic_type) @cap)

    ; Calls
    ((call_expression) @cap)
]]

local lua_query = [[
            ;; query
            ((identifier) @cap)
            ("string_content" @cap)
            ((true) @cap)
            ((false) @cap)
        ]]

local python_query = [[
            ;; query
            ((identifier) @cap)
            ((string) @cap)
        ]]

local queries = {
  c = c_query,
  cpp = cpp_query,
  go = go_query,
  rust = rust_query,
  lua = lua_query,
  python = python_query,
}

M.keys = {
  {
    "<M-j>",
    function()
      local se = require("SelectEase")
      se.select_node {
        queries = queries,
        direction = "next",
        vertical_drill_jump = true,
        fallback = function()
          se.select_node { queries = queries, direction = "previous" }
        end,
      }
    end,
    mode = { "n", "s", "i" },
  },
  {
    "<M-k>",
    function()
      local se = require("SelectEase")
      se.select_node {
        queries = queries,
        direction = "previous",
        vertical_drill_jump = true,
        fallback = function()
          se.select_node { queries = queries, direction = "next" }
        end,
      }
    end,
    mode = { "n", "s", "i" },
  },
  {
    "<M-h>",
    function()
      local se = require("SelectEase")
      se.select_node {
        queries = queries,
        direction = "previous",
        current_line_only = true,
      }
    end,
    mode = { "n", "s", "i" },
  },
  {
    "<M-l>",
    function()
      local se = require("SelectEase")
      se.select_node {
        queries = queries,
        direction = "next",
        current_line_only = true,
      }
    end,
    mode = { "n", "s", "i" },
  },
}

return M
