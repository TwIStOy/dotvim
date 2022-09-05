local M = {}

M.append_folder_name = function(keys, name)
  local wk = require 'which-key'
  local key = table.concat(keys, '')
  wk.register { [key] = { name = name } }
end

M.map = function(opt, bufnr)
  local wk = require 'which-key'
  local mapping_opt = {}
  mapping_opt.mode = opt.mode or 'n'
  mapping_opt.silent = opt.silent or true
  mapping_opt.noremap = opt.noremap or true
  mapping_opt.nowait = opt.nowait or false
  mapping_opt.buffer = bufnr

  if opt.desc == nil then
    if type(opt.action) == "function" then
      opt.desc = 'NO-TAG'
    else
      opt.desc = opt.action
    end
  end

  local key = table.concat(opt.keys, '')
  if opt.action ~= nil then
    wk.register({ [key] = { opt.action, opt.desc } }, mapping_opt)
  else
    wk.register({ [key] = { opt.desc } }, mapping_opt)
  end
end

M.ft_map = function(ft, opt)
  local event = require 'ht.core.event'
  event.on('FileType', {
    pattern = ft,
    callback = function()
      M.map(opt, 0)
    end,
  })
end

M.ft_maps = function(ft, mappings)
  local event = require 'ht.core.event'
  event.on('FileType', {
    pattern = ft,
    callbacck = function()
      for _, v in ipairs(mappings) do
        M.map(v, 0)
      end
    end,
  })
end

return M

-- vim: et sw=2 ts=2

