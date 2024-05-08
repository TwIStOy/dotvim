local MenuText = require("right-click.components.text")
local Config = require("right-click.config").config

---@class dotvim.extra.ui.context_menu.MenuItem
---@field text dotvim.extra.ui.context_menu.MenuText
---@field children dotvim.extra.ui.context_menu.MenuItem[]
---@field desc? string
---@field callback function
---@field keys table<string, boolean>
---@field extra_keys table<number, string>
---@field disabled? boolean
local MenuItem = {}

---@class dotvim.extra.ui.context_menu.MenuItemOptions
---@field text string
---@field children? dotvim.extra.ui.context_menu.MenuItemOptions[]
---@field desc? string
---@field callback? function
---@field keys? string[]
---@field disabled? boolean
local MenuItemOptions = {}

local function disable_builtin_keys(keys)
  keys["j"] = false
  keys["k"] = false
  keys["h"] = false
  keys["l"] = false
  keys["q"] = false
  keys["<ESC>"] = false
  keys["<C-c>"] = false
  keys["<CR>"] = false
  keys["<TAB>"] = false
  keys["<S-TAB>"] = false
  keys["<C-n>"] = false
  keys["<C-p>"] = false
  keys["<UP>"] = false
  keys["<DOWN>"] = false
  return keys
end

---@param opts dotvim.extra.ui.context_menu.MenuItemOptions
---@return dotvim.extra.ui.context_menu.MenuItem?
local function new_item(opts)
  local text = opts[1]
  if text == nil then
    return nil
  end

  local this = {
    text = MenuText(text),
    children = nil,
    desc = opts.desc,
    callback = opts.callback,
    keys = {},
    extra_keys = {},
    disabled = opts.disabled,
  }

  -- setup keys and pos from parsed text
  for key, _ in pairs(this.text.keys) do
    this.keys[key] = true
  end

  -- setup keys from opts
  if opts.keys ~= nil then
    if type(opts.keys) == "string" then
      opts.keys = {
        opts.keys --[[@as string]],
      }
    end

    if vim.isarray(opts.keys) then
      for _, key in ipairs(opts.keys) do
        this.keys[key] = true
        table.insert(this.extra_keys, key)
      end
    end
  end
  this.keys = disable_builtin_keys(this.keys)
  table.sort(this.extra_keys)

  if opts.children ~= nil and vim.isarray(opts.children) then
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
  if self.text.raw_text == "---" then
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
function MenuItem:into_nui_node(text_width)
  local nui_menu = require("nui.menu")
  if self.text.raw_text == "---" then
    -- separator
    return nui_menu.separator(nil, { "-" })
  end

  local opts = { menu_item = self }
  local text = self.text:into_nui_line()

  local length = self.text:length()

  if self.extra_keys ~= nil and #self.extra_keys > 0 then
    local hint = table.concat(self.extra_keys, "|")
    -- always reserve 2 spaces for arrow
    local space_count = text_width - 2 - length - #hint
    if space_count > 0 then
      text:append(string.rep(" ", space_count))
    end
    text:append(hint, Config.highlight.key)
    length = length + space_count + #hint
  end

  if self.children ~= nil and #self.children > 0 and text_width ~= nil then
    local spaces = text_width - length - 2
    if spaces > 0 then
      text:append(string.rep(" ", spaces))
    end
    text:append(Config.expandable_sign)
  end
  return nui_menu.item(text, opts)
end

return new_item
