---@diagnostic disable: param-type-mismatch
local BufferCondition = require("ht.core.buf-condition")

---@class ht.right_click.Database
---@field private _sections ht.right_click.SectionStorage[]
---@field private _cache FuncCache
local Database = {}

---@class ht.right_click.SectionStorage
---@field index number
---@field items ht.right_click.MenuItemOptions[]
---@field condition ht.BufferCondition

---@class ht.right_click.SectionOpts
---@field index number?
---@field items ht.right_click.MenuItemOptions[]
---@field condition ht.BufferCondition|fun(buf: VimBuffer):boolean|nil

---@param opts ht.right_click.SectionOpts
function Database:add(opts)
  ---@type ht.BufferCondition
  local cond
  if opts.condition ~= nil then
    if type(opts.condition) == "function" then
      cond = BufferCondition.new(opts.condition)
    else
      ---@diagnostic disable-next-line: cast-local-type
      cond = opts.condition
    end
  else
    cond = BufferCondition.yes()
  end

  self._sections[#self._sections + 1] = {
    index = opts.index or 0,
    items = opts.items,
    ---@diagnostic disable-next-line: assign-type-mismatch
    condition = cond,
  }
  self._cache:clear()
  return self
end

function Database:mount()
  local Menu = require("ht.core.right-click.component.menu")
  local buffer = require("ht.core.vim.buffer")()
end

-- function Db:show()
--   local ContextMenu = require("right-click.components.menu")
--   local buf = vim.api.nvim_get_current_buf()
--   local ft = vim.bo.filetype
--   local filename = vim.fn.expand("%:t")
--   ---@type SectionInfo[]
--   local opts = {}
--   for _, section in ipairs(self.sections) do
--     if section.enabled(buf, ft, filename) then
--       table.insert(opts, section)
--     end
--   end
--   table.sort(opts, function(a, b)
--     local a_index = a.index or 0
--     local b_index = b.index or 0
--     return a_index < b_index
--   end)
--   local res = {}
--   for _, section in ipairs(opts) do
--     if #res > 0 then
--       table.insert(res, { "---" })
--     end
--     vim.list_extend(res, section.items)
--   end
--   if #res > 0 then
--     local menu = ContextMenu(res)
--     menu:as_nui_menu():mount()
--   else
--     vim.notify("No right-click menu items available")
--   end
-- end
--
-- local M = {}
--
-- function M.new_db()
--   local db = {
--     sections = {},
--   }
--   setmetatable(db, { __index = Db })
--   return db
-- end
--
-- return M
