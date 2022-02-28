module('ht.features.mkdir', package.seeall)

local fn = vim.fn
local cv = require 'ht.core.vim'

local function mkdir()
  local dir = fn.expand('<afile>:p:h')

  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, 'p')
  end
end

cv.event.BufWritePre.on('*', function()
  mkdir()
end, 'create missing directories on saving a file')

-- vim: et sw=2 ts=2 fdm=marker

