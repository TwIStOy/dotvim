module('ht.core.highlight', package.seeall)

function Hi(opts)
  print(vim.inspect(opts))
  for group_name, definition in pairs(opts) do
    local cmd = 'hi! ' .. group_name
    local count = 0
    for key, arg in pairs(definition) do
      if arg ~= nil then
        if type(arg) == 'string' then
          count = count + 1
          cmd = cmd .. string.format(' %s=%s', key, arg)
        end
        if type(arg) == 'number' then
          count = count + 1
          cmd = cmd .. string.format(' %s=#%x', key, arg)
        end
      end
    end
    if count > 0 then
      vim.api.nvim_command(cmd)
    end
  end
end

function Foreground(group_name)
  return vim.api.nvim_get_hl_by_name(group_name, 1).foreground
end

function Background(group_name)
  return vim.api.nvim_get_hl_by_name(group_name, 1).background
end

-- vim: et sw=2 ts=2

