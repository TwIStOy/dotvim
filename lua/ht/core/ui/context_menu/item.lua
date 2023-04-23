local ui_text = require 'ht.core.ui.text'

---@class ContextMenuItem
---@field text string text to display
---@field keys table<string, boolean>
---@field keys_positions integer[]
---@field desc string|nil
---@field callback function callback when confirm with this item is selected
---@field children ContextMenuItem[]|nil
---@field in_menu NuiMenu
local ContextMenuItem = {}

local function disable_builtin_keys(keys)
  keys['j'] = false
  keys['k'] = false
  keys['h'] = false
  keys['l'] = false
  keys['<ESC>'] = false
  keys['<C-c>'] = false
  keys['<CR>'] = false
  keys['<TAB>'] = false
  keys['<S-TAB>'] = false
  keys['<C-n>'] = false
  keys['<C-p>'] = false
  keys['<UP>'] = false
  keys['<DOWN>'] = false
  return keys
end

---@return ContextMenuItem
local function empty_context_menu_item()
  local res = { keys = {}, keys_positions = {} }
  setmetatable(res, { __index = ContextMenuItem })
  return res
end

---@param opts table
---@return ContextMenuItem|nil
function ContextMenuItem.new(opts)
  local text = opts[1]
  if text == nil then
    return nil
  end
  local res = empty_context_menu_item()

  text = ui_text.parse_ui_text(text)
  res.text = text.text

  -- setup keys and pos from parsed text
  for key, pos in pairs(text.keys) do
    res.keys[key] = true
    table.insert(res.keys_positions, pos)
  end

  -- setup keys from opts
  if opts.keys ~= nil and vim.tbl_isarray(opts.keys) then
    for _, key in ipairs(opts.keys) do
      res.keys[key] = true
    end
  end
  res.keys = disable_builtin_keys(res.keys)

  if opts.command ~= nil then
    res.callback = function()
      vim.cmd(opts.command)
    end
  end
  if opts.action ~= nil then
    res.callback = opts.action
  end
  if opts.children ~= nil and vim.tbl_isarray(opts.children) then
    res.children = {}
    for _, child in ipairs(opts.children) do
      local c = ContextMenuItem.new(child)
      if c ~= nil then
        table.insert(res.children, c)
      end
    end
  end

  return res
end

---@param text_width integer fix current text's width to
---@return NuiTreeNode
function ContextMenuItem:as_nui_menu_item(text_width)
  ---@type NuiMenu
  local nui_menu = require 'nui.menu'
  local opts = { menu_item = self }

  local text = self.text
  if self.children ~= nil and #self.children > 0 then
    -- if has children, add ' ▶' at the end
    text = self.text .. string.rep(' ', text_width - #self.text) .. ' ▶'
  end

  return nui_menu.item(text, opts)
end

return ContextMenuItem
