local M = {}

M.core = { 'AndrewRadev/sideways.vim',
           cmd = { 'SidewaysLeft', 'SidewaysRight' } }

M.setup = function() -- code to run before plugin loaded
  local dropbox = require 'ht.core.dropbox'

  dropbox:append_context('*', {
    { 'Move Object &Left', 'SidewaysLeft' },
    { 'Move Object &Right', 'SidewaysRight' },
  })
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

