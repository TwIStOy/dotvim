module('ht.core.dropdown', package.seeall)

local va = vim.api
local DROPDOWN_VAR_NAME = '_dotvim_dropdown_context'

function GetContext(bufnr)
  if vim.fn['exists']('b:_dotvim_dropdown_context') == 0 then
    va.nvim_buf_set_var(bufnr, DROPDOWN_VAR_NAME, {})
  end

  local r = va.nvim_buf_get_var(bufnr, DROPDOWN_VAR_NAME)
  if r == nil then
    return {}
  else
    return r
  end
end

function AddBufContext(bufnr, ctx)
  local r = GetContext(bufnr)
  if #r > 0 then
    vim.list_extend(r, { '-' })
  end
  vim.list_extend(r, ctx)
  va.nvim_buf_set_var(bufnr, DROPDOWN_VAR_NAME, r)
end

local dropdown_context = {}

function AppendContext(ft, ctx)
  if dropdown_context[ft] == nil then
    dropdown_context[ft] = {}
  end

  vim.list_extend(dropdown_context[ft], { ctx })
end

function extend_context(context, v)
  if #context > 0 then
    vim.list_extend(context, { '-' })
  end

  vim.list_extend(context, v)
  return context
end

function PrepareContext(ft)
  local context = GetContext(0)

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

