local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local trig_engines = require("ht.snippets.trig_engines")
local events = require("luasnip.util.events")

local function ts_postfix_maker(types)
  return function(opts)
    opts.engine = trig_engines.ts_topmost_parent(types)
    opts.hidden = true
    opts.opts = {
      callbacks = {
        [-1] = {
          ---@diagnostic disable-next-line: unused-local
          [events.pre_expand] = function(node, _event_args)
            local postfix_env_override = {
              env_override = {
                POSTFIX_MATCH = node.captures[1],
              },
            }
            return postfix_env_override
          end,
        },
      },
    }
    return snippet(opts)
  end
end

local any_expr_types = {
  "call_expression",
  "identifier",
  "template_function",
  "subscript_expression",
  "field_expression",
  "user_defined_literal",
}

local indent_only_types = {
  "identifier",
  "field_identifier",
}

return {
  ts_postfix_maker = ts_postfix_maker,
  any_expr_types = any_expr_types,
  indent_only_types = indent_only_types,
  cpp_ts_postfix_any_expr = ts_postfix_maker(any_expr_types),
  cpp_ts_postfix_ident_only = ts_postfix_maker(indent_only_types),
}
