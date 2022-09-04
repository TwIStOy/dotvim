local M = {}

local hut = require 'ht.utils.table'

local function create_table(keys, name)
  local res = { name = name }
  if #keys == 0 then
    return res
  end
  res[keys[1]] = res[hut.slice(keys, 2)]
  return res
end

M.append_folder_name = function(keys, name)
  local wk = require 'which-key'
  wk.register(create_table(keys, name))
end

M.map = function(opt, bufnr)
  local wk = require 'which-key'
  local mapping_opt = {}
  mapping_opt.mode = opt.mode or 'n'
  mapping_opt.silent = opt.silent or true
  mapping_opt.noremap = opt.noremap or true
  mapping_opt.nowait = opt.nowait or false
  mapping_opt.buffer = bufnr
  wk.register(opt, mapping_opt)
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

