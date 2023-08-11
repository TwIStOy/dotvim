---@diagnostic disable: param-type-mismatch
local BufferCondition = require("ht.core.buf-condition")

---@class ht.right_click.Database
---@field private _dynamic_sections ht.right_click.SectionStorage[]
---@field private _static_sections ht.right_click.SectionStorage[]
---@field private _cache FuncCache
local Database = {}

---@class ht.right_click.SectionStorage
---@field index number
---@field items ht.right_click.MenuItemOptions[]
---@field condition ht.BufferCondition

---@class ht.right_click.SectionOpts
---@field index number?
---@field items ht.right_click.MenuItemOptions[]
---@field dynamic boolean?
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
  local dynamic = opts.dynamic or false

  local section = {
    index = opts.index or 0,
    items = opts.items,
    ---@diagnostic disable-next-line: assign-type-mismatch
    condition = cond,
  }
  if dynamic then
    self._dynamic_sections[#self._dynamic_sections + 1] = section
  else
    self._static_sections[#self._static_sections + 1] = section
    self._cache:clear()
  end
  return self
end

function Database:mount()
  local Menu = require("ht.core.right-click.component.menu")
  local buffer = require("ht.core.vim.buffer")()
  local sections = {}
  for _, section in ipairs(self._dynamic_sections) do
    if section.condition(buffer) then
      sections[#sections + 1] = section
    end
  end
  sections = vim.list_extend(
    sections,
    self._cache:ensure(buffer:to_cache_key(), function()
      ---@type ht.right_click.SectionStorage[]
      local res = {}
      for _, section in ipairs(self._static_sections) do
        if section.condition(buffer) then
          res[#res + 1] = section
        end
      end
      return res
    end)
  )
  table.sort(sections, function(a, b)
    local a_index = a.index or 0
    local b_index = b.index or 0
    return a_index < b_index
  end)
  local lines = {}
  for _, section in ipairs(sections) do
    if #lines > 0 then
      lines[#lines + 1] = { "---" }
    end
    vim.list_extend(lines, section.items)
  end
  if #lines > 0 then
    local menu = Menu.new(lines)
    menu:as_nui_menu():mount()
  else
    vim.notify("No right-click menu items available")
  end
end

function Database.new()
  local db = {
    _dynamic_sections = {},
    _static_sections = {},
    _cache = require("ht.utils.cache").new(),
  }
  setmetatable(db, { __index = Database })
  return db
end

return Database
