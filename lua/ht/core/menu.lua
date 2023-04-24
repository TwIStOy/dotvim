local M = {}

-- util functions to build right-click-like menu

M.menus = {}
M.filename_menus = {}

M.sections = {}

--[[
Simple menu item
{
  "text", -- text to display
  {
    callback = function() end, -- function to call when item is selected
  }
}

Complex menu item with sub-menu
{
  "text", -- text to display
  {
    children = {
      -- sub-menu items
    }
  }
}

--]]

---@class NewSectionOptions
---@field filetype string|table|nil
---@field filename string|table|nil
---@field index number|nil
---@field opts Array<MenuItemOptions>
local NewSectionOptions = {}

function NewSectionOptions:match(ft, filename)
  if self.filetype ~= nil then
    if type(self.filetype) == 'string' then
      if ft ~= self.filetype then
        return false
      end
    elseif type(self.filetype) == 'table' and vim.tbl_isarray(self.filetype) then
      if not vim.list_contains(self.filetype, ft) then
        return false
      end
    end
  end
  if self.filename ~= nil then
    if type(self.filename) == 'string' then
      if filename ~= self.filename then
        return false
      end
    elseif type(self.filename) == 'table' and vim.tbl_isarray(self.filename) then
      if not vim.list_contains(self.filename, filename) then
        return false
      end
    end
  end

  return true
end

---@param opts NewSectionOptions
function M:add_section(opts)
  setmetatable(opts, { __index = NewSectionOptions })
  table.insert(self.sections, opts)
end

function M:mount()
  local context_menu = require 'ht.core.ui.components.context_menu'
  local ft = vim.bo.filetype
  local filename = vim.fn.expand('%:t')
  local opts = {}
  for _, section in ipairs(self.sections) do
    if section:match(ft, filename) then
      table.insert(opts, section)
    end
  end
  table.sort(opts, function(a, b)
    local a_index = a.index or 0
    local b_index = b.index or 0
    return a_index < b_index
  end)
  local res = {}
  for _, section in ipairs(opts) do
    if #res > 0 then
      table.insert(res, { '---' })
    end
    vim.list_extend(res, section.opts)
  end
  local menu = context_menu(res)
  menu:as_nui_menu():mount()
end

function M:append_section()
end

function M:append_file_section()
end

return M
