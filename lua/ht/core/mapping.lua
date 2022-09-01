local M = {}

local hut = require 'ht.utils.table'

local filetype_mappings = { ft = '*', mappings = {} }

filetype_mappings.new = function(self, ft)
  local new_obj = vim.deepcopy(self)
  new_obj.ft = ft
  return new_obj
end

filetype_mappings._goto = function(self, folder, root)
  local now = root or self.mappings
  if #folder == 0 then
    return now
  end

  local key = folder[1]
  if now[key] == nil then
    now[key] = {}
  end

  return self:_goto(now[key], hut.slice(folder, 2))
end

filetype_mappings.append_folder_name = function(self, folder, name)
  local folder_table = self:_goto(folder)
  if folder_table.name ~= nil then
    table.insert(folder_table.name, name)
    hut.unique(folder_table)
  else
    folder_table.name = { name }
  end
end

local function create_table(keys, action, desc)
  local res = { action, desc }
  if #keys == 0 then
    return res
  end
  res[keys[1]] = res[hut.slice(keys, 2)]
  return res
end

filetype_mappings.map = function(self, opt, buffer)
  if opt.keys == nil or #opt.keys == 0 then
    error [[invalid 'keys' in opt]]
  end
  -- generate wk table
  local tbl = create_table(opt.keys, opt.action, opt.desc)
  local mapping_opt = {}

  mapping_opt.mode = opt.mode or 'n'
  mapping_opt.silent = opt.silent or true
  mapping_opt.noremap = opt.noremap or true
  mapping_opt.nowait = opt.nowait or false

  if self.ft == '*' then
    mapping_opt.buffer = nil
    local wk = require("which-key")
    wk.register(tbl, mapping_opt)
  else
    if buffer == nil then
      -- recording call
      table.insert(self.mappings, { tbl, mapping_opt })
    else
      -- register call
      mapping_opt.buffer = buffer
      local wk = require("which-key")
      wk.register(tbl, mapping_opt)
    end
  end
end

filetype_mappings.register = function(self, buffer)
  if self.ft == '*' then
    return
  else
    local wk = require("which-key")
    for _, v in ipairs(self.mappings) do
      v[2].buffer = buffer
      wk.register(v[1], v[2])
    end
  end
end

M.filetypes = {}

M.append_folder_name = function(self, ft, folder, name)
  if self.filetypes[ft] ~= nil then
    self.filetypes[ft] = filetype_mappings:new(ft)
  end

  self.filetypes[ft]:append_folder_name(folder, name)
end

M.map = function(self, ft, opt)
  if self.filetypes[ft] ~= nil then
    self.filetypes[ft] = filetype_mappings:new(ft)
  end

  self.filetypes[ft]:map(opt)
end

return M

-- vim: et sw=2 ts=2

