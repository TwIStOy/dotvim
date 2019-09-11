module('logging', package.seeall)

function WriteLog(line)
  fout = io.open(vim.api.nvim_get_var('_log_file_path'), 'a')
  if fout == nil then
    return
  end
  fout:write(line .. '\n')
  fout:close()
end

-- debug 1
-- info  2
-- warn  3
-- error 4
function LogEnabled(lvl)
  return lvl >= vim.api.nvim_get_var('_dotvim_minlvl')
end

function LogInfo(...)
  if not LogEnabled(2) then
    return
  end

  LogImpl(' INFO', ...)
end

function LogImpl(lvl_msg, ...)
  local line = '[' .. lvl_msg .. '] '
    .. os.date("%m-%d %H:%M:%S")
    .. ' [' .. vim.api.nvim_eval('expand("%:t")') .. '] '
  local args = {...}

  for i,v in ipairs(args) do
    line = line .. v
  end

  WriteLog(line)
end

