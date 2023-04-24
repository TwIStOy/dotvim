---@class MenuItem
---@field text MenuText
---@field children MenuItem[]
---@field desc string|nil
---@field callback function
---@field keys table<string, boolean>
---@field extra_keys Array<string>
local MenuItem = {}

---@class MenuItemOptions
---@field text string
---@field children MenuItemOptions[]
---@field desc string|nil
---@field callback function
---@field keys string[]
local MenuItemOptions = {}

local function disable_builtin_keys(keys)
  keys['j'] = false
  keys['k'] = false
  keys['h'] = false
  keys['l'] = false
  keys['q'] = false
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

---@return MenuItem|nil
local function new_item(opts)
  local menu_text = require 'ht.core.ui.components.menu_text'
  local text = opts[1]
  if text == nil then
    return nil
  end

  local this = {
    text = menu_text(text),
    children = nil,
    desc = opts.desc,
    callback = opts.callback,
    keys = {},
    extra_keys = {},
  }

  -- setup keys and pos from parsed text
  for key, _ in pairs(this.text.keys) do
    this.keys[key] = true
  end

  -- setup keys from opts
  if opts.keys ~= nil then
    if type(opts.keys) == "string" then
      opts.keys = { opts.keys }
    end

    if vim.tbl_isarray(opts.keys) then
      for _, key in ipairs(opts.keys) do
        this.keys[key] = true
        table.insert(this.extra_keys, key)
      end
    end
  end
  this.keys = disable_builtin_keys(this.keys)
  table.sort(this.extra_keys)

  if opts.children ~= nil and vim.tbl_isarray(opts.children) then
    this.children = {}
    for _, child in ipairs(opts.children) do
      local c = new_item(child)
      if c ~= nil then
        table.insert(this.children, c)
      end
    end
  end

  setmetatable(this, { __index = MenuItem })
  return this
end

---@return number
function MenuItem:expected_length()
  if self.text.raw_text == '---' then
    return 0
  end

  -- text part
  local len = self.text:length()

  if #self.extra_keys > 0 then
    -- add spaces
    len = len + #self.extra_keys + 3
    for _, key in ipairs(self.extra_keys) do
      len = len + #key
    end
  end

  if self.children ~= nil and #self.children > 0 then
    -- add arrow
    len = len + 2
  end

  return len
end

---@param text_width number
---@return NuiTreeNode
function MenuItem:as_nui_node(text_width)
  local nui_menu = require 'nui.menu'
  if self.text.raw_text == '---' then
    -- separator
    return nui_menu.separator(nil, { '-' })
  end

  local opts = { menu_item = self }
  local text = self.text:as_nui_line("@variable.builtin")

  local length = self.text:length()

  if self.extra_keys ~= nil and #self.extra_keys > 0 then
    local hint = table.concat(self.extra_keys, "|")
    -- always reserve 2 spaces for arrow
    local space_count = text_width - 2 - length - #hint
    if space_count > 0 then
      text:append(string.rep(' ', space_count))
    end
    text:append(hint, "@variable.builtin")
    length = length + space_count + #hint
  end

  if self.children ~= nil and #self.children > 0 and text_width ~= nil then
    local spaces = text_width - length - 2
    if spaces > 0 then
      text:append(string.rep(' ', spaces))
    end
    text:append(" ▶")
  end
  return nui_menu.item(text, opts)
end

return new_item
