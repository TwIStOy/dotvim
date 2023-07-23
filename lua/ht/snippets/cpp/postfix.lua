local ls = require("luasnip")
local ms = ls.multi_snippet
local events = require("luasnip.util.events")

local ident_pattern = "*?[%a_][%w_]*"
local tpl_pattern = "%b<>"
local call_pattern = "%b()"
local at_pattern = "%b[]"

local optional_parts = {
  tpl_pattern,
  at_pattern,
  call_pattern,
  at_pattern,
}

-- generate all possible 2^#optional_parts combinations of optional parts
local expr_patterns = {}
for i = 0, 2 ^ #optional_parts do
  local parts = { ident_pattern }
  for j = 1, #optional_parts do
    if i % 2 == 1 then
      parts[#parts + 1] = optional_parts[j]
    end
    i = math.floor(i / 2)
  end
  expr_patterns[#expr_patterns + 1] = table.concat(parts, "")
end

local function build_expr_postfix_context(raw_suffix)
  local suffix = "%." .. raw_suffix
  local context = {}
  for i, pattern in ipairs(expr_patterns) do
    context[i] = {
      trig = pattern .. suffix,
      regTrig = true,
      name = "." .. raw_suffix,
      dscr = "Postfix " .. raw_suffix,
      hidden = true,
      show_condition = function(line_to_cursor)
        local test_pattern = pattern
        local m = line_to_cursor:match(test_pattern .. "$")
        if m ~= nil then
          return true
        end
        test_pattern = pattern .. "%."
        m = line_to_cursor:match(test_pattern .. "$")
        if m ~= nil then
          return true
        end
        for j = 1, #raw_suffix do
          local c = raw_suffix:sub(1, j)
          test_pattern = test_pattern .. c
          m = line_to_cursor:match(test_pattern .. "$")
          if m ~= nil then
            return true
          end
        end
        return false
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
