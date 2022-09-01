local M = {}

local hut = require 'ht.utils.table'

local filetype_mappings = {
  mappings = {},

  _goto = function(self, folder, root)
    local now = root or self.mappings
    if #folder == 0 then
      return now
    end

    local key = folder[1]
    if now[key] == nil then
      now[key] = {}
    end

    return self:_goto(now[key], hut.slice(folder, 2))
  end,

  append_folder_name = function(self, folder, name)
    local folder_table = self:_goto(folder)
    if folder_table.name ~= nil then
      table.insert(folder_table.name, name)
      hut.unique(folder_table)
    else
      folder_table.name = { name }
    end
  end,
}

M.filetypes = {}

M.append_folder_name = function(self, ft, folder, name)
  if self.filetypes[ft] ~= nil then
    self.filetypes[ft] = vim.deepcopy(filetype_mappings)
  end

  self.filetypes[ft]:append_folder_name(folder, name)
end

return M

-- vim: et sw=2 ts=2

