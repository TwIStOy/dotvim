local M = {}

local A = vim.api
local augroup = { id = 0 }

augroup.new = function(self, name, opts)
  local new_obj = vim.deepcopy(self)
  new_obj.id = A.nvim_create_augroup(name, opts)
  return new_obj
end

augroup.destroy = function(self)
  A.nvim_del_augroup_by_id(self.id)
end

augroup.on = function(self, event, _opt)
  local opt = _opt or {}
  opt.group = self.id
  A.nvim_create_autocmd(event, opt)
end

M.group = augroup
M.on = function(event, _opt)
  A.nvim_create_autocmd(event, _opt)
end

return M
