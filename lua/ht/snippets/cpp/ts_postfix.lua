local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local ts_resolver = require("ht.snippets.resolvers.ts_resolver")

local function ts_postfix_maker(types)
  return function(opts)
    opts.engine = "plain"
    opts.hidden = true
    opts.resolveExpandParams = ts_resolver.make_ts_topmost_parent(types)
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
