module('ht.core.dropdown', package.seeall)

local dropdown_context = {}

function AppendContext(ft, ctx)
  if dropdown_context[ft] == nil then
    dropdown_context[ft] = {}
  end

  vim.list_extend(dropdown_context[ft], {ctx})
end

function extend_context(context, v)
  if #context > 0 then
    vim.list_extend(context, {'-'})
  end

  vim.list_extend(context, v)
  return context
end

function PrepareContext(ft)
  local context = {}

  if dropdown_context['*'] ~= nil then
    for i, v in ipairs(dropdown_context['*']) do
      context = extend_context(context, v)
    end
  end

  if dropdown_context[ft] ~= nil then
    for i, v in ipairs(dropdown_context[ft]) do
      context = extend_context(context, v)
    end
  end

  return context
end

-- vim: et sw=2 ts=2

