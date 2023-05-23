local ls = require("luasnip")
local ms = ls.multi_snippet
local events = require("luasnip.util.events")

local ident_pattern = "*?[%a_][%w_]*"
local tpl_pattern = "%b<>"
local call_pattern = "%b()"

local function concat_patterns(...)
  local patterns = { ... }
  return table.concat(patterns, "")
end

local expr_patterns = {
  concat_patterns(ident_pattern, tpl_pattern, call_pattern),
  concat_patterns(ident_pattern, tpl_pattern),
  concat_patterns(ident_pattern, call_pattern),
  concat_patterns(ident_pattern),
}

local function build_expr_postfix_context(raw_suffix)
  local suffix = "%." .. raw_suffix
  local context = {}
  for i, pattern in ipairs(expr_patterns) do
    context[i] = {
      trig = pattern .. suffix,
      regTrig = true,
      name = "." .. raw_suffix,
      dscr = "Postfix " .. raw_suffix,
      show_condition = function(line_to_cursor)
        return line_to_cursor:match(pattern .. suffix .. "$") ~= nil
      end,
    }
  end
  return context
end

local function postfix(suffix, nodes)
  local context = build_expr_postfix_context(suffix)

  local function match_postfix(text)
    for _, pattern in ipairs(expr_patterns) do
      local res = text:match("(" .. pattern .. ")%." .. suffix .. "$")
      if res ~= nil then
        return res
      end
    end
  end

  return ms(context, nodes, {
    common_opts = {
      callbacks = {
        [-1] = {
          [events.pre_expand] = function(node, _event_args)
            local postfix_match = match_postfix(node.trigger) or ""
            local postfix_env_override = {
              env_override = {
                POSTFIX_MATCH = postfix_match,
              },
            }
            return postfix_env_override
          end,
        },
      },
    },
  })
end

return {
  postfix = postfix,
  expr_patterns = expr_patterns,
}
