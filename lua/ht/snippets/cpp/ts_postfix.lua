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

return {
  cpp_ts_postfix_any_expr = ts_postfix_maker {
    "call_expression",
    "identifier",
    "template_function",
    "subscript_expression",
    "field_expression",
  },
  cpp_ts_postfix_ident_only = ts_postfix_maker {
    "identifier",
    "field_identifier",
  },
}
