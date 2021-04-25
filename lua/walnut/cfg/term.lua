module('walnut.cfg.term', package.seeall)

local term = require('toggleterm')

local function cwd()
  if vim.b._dotvim_resolved_project_root ~= nil then
    return vim.b._dotvim_resolved_project_root
  else
    return vim.api.nvim_call_function('getcwd', {})
  end
end

function input_cmd_and_exec()
  local cur = cwd()
  local cmd = vim.api.nvim_call_function('input', {cur .. ' > '})
  if #cmd > 0 then
    term.exec(cmd, 1, nil, cur)
  end
end


