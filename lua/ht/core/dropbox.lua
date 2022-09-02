local M = {}

local F = vim.fn
local A = vim.api
local _DROPBOX_VAR_ = '_dotvim_dropdown_context'

M.dropboxes = {}

local function simple_extend_context(ctx, v)
  if #ctx > 0 then
    vim.list_extend(ctx, { '-' })
  end
  vim.list_extend(ctx, v)
  return ctx
end

local function get_buffer_context(bufnr)
  if F['exists']('b:' .. _DROPBOX_VAR_) == 0 then
    A.nvim_buf_set_var(bufnr, _DROPBOX_VAR_, {})
  end

  return A.nvim_buf_get_var(bufnr, _DROPBOX_VAR_) or {}
end

M.append_context = function(self, ft, ctx)
  if self.dropboxes[ft] == nil then
    self.dropboxes[ft] = {}
  end
  vim.list_extend(self.dropboxes[ft], { ctx })
end

M.get_context = function(self, ft)
  local ctx = get_buffer_context(0)

  if self.dropboxes['*'] ~= nil then
    for _, v in ipairs(self.dropboxes['*']) do
      ctx = simple_extend_context(ctx, v)
    end
  end

  if self.dropboxes[ft] ~= nil then
    for _, v in ipairs(self.dropboxes['*']) do
      ctx = simple_extend_context(ctx, v)
    end
  end

  return ctx
end

M.append_buf_context = function(bufnr, _ctx)
  local ctx = get_buffer_context(bufnr)
  A.nvim_buf_set_var(bufnr, _DROPBOX_VAR_, simple_extend_context(ctx, _ctx))
end

M.setup = function(self, ft, bufnr)
  local ctx = self:get_context(ft)
  A.nvim_buf_set_var(bufnr or 0, _DROPBOX_VAR_, ctx)
end

return M
