local M = {}

local fn = vim.fn
local event = require 'ht.core.event'

local function mkdir()
  local dir = fn.expand('<afile>:p:h')

  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, 'p')
  end
end

function M.register_create_directory_before_save()
  event.on('BufWritePre', {
    pattern = '*',
    callback = function()
      mkdir()
    end
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

