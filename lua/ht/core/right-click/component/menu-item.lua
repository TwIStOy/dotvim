local MenuText = require("ht.core.right-click.component.text")
local UtilsTable = require("ht.utils.table")

---@class ht.right_click.MenuItemOptions
---@field text ht.right_click.MenuText
---@field children ht.right_click.MenuItemOptions[]
---@field desc string?
---@field callback fun()
---@field keys string[]
local MenuItemOptions = {}

---@class ht.right_click.MenuItem: ht.right_click.MenuItemOptions
---@field extra_keys string[]
---@field rendering_context table<string, any>
local MenuItem = {}

local disable_builtin_keys = {
  ["j"] = false,
  ["k"] = false,
  ["h"] = false,
  ["l"] = false,
  ["q"] = false,
  ["<ESC>"] = false,
  ["<C-c>"] = false,
  ["<CR>"] = false,
  ["<TAB>"] = false,
  ["<S-TAB>"] = false,
  ["<C-n>"] = false,
  ["<C-p>"] = false,
  ["<UP>"] = false,
  ["<DOWN>"] = false,
}

---@param opts ht.right_click.MenuItemOptions
---@return ht.right_click.MenuItem?
function MenuItem.new(opts)
  if opts[1] == nil then
    return nil
  end

  local text = MenuText.new(opts[1])
  local keys = {}
  local extra_keys = {}

  -- setup keys and pos from parsed text
  for _, key in ipairs(text:keys()) do
    keys[key] = true
  end

  -- setup keys from opts
  if opts.keys ~= nil then
    if type(opts.keys) == "string" then
      keys[opts.keys] = true
      extra_keys[#extra_keys + 1] = opts.keys
    elseif vim.tbl_isarray(opts.keys) then
      for _, key in ipairs(opts.keys) do
        keys[key] = true
        extra_keys[#extra_keys + 1] = key
      end
    end
  end

  keys = vim.tbl_extend("force", keys, disable_builtin_keys)
  table.sort(extra_keys)

  local children = {}
  if opts.children and vim.tbl_isarray(opts.children) then
    for _, child in ipairs(opts.children) do
      local c = MenuItem.new(child)
      if c then
        children[#children + 1] = c
      end
    end
  end

  return setmetatable({
    text = text,
    children = children,
    desc = opts.desc,
    callback = opts.callback,
    keys = UtilsTable.valid_keys(keys),
    extra_keys = extra_keys,
    rendering_context = {},
  }, { __index = MenuItem })
end

---@return number
function MenuItem:length()
  if self.text:is_separator() then
    return 0
  end

  local len = self.text:length()

  if #self.extra_keys > 0 then
    len = len + #self.extra_keys + 3
    for _, key in ipairs(self.extra_keys) do
      len = len + #key
    end
  end

  if #self.children > 0 then
    len = len + 2
  end

  return len
end

---@param text_width number
---@return NuiTreeNode
function MenuItem:as_nui_node(text_width)
  local nui_menu = require("nui.menu")
  if self.text:is_separator() then
    return nui_menu.separator(nil, { "-" })
  end

  local text = self.text:as_nui_line()
  local current_length = self.text:length()

  if #self.extra_keys > 0 then
    local hint = table.concat(self.extra_keys, "|")
    local space_count = text_width - 2 - current_length - #hint
    assert(space_count >= 0, "space_count should be positive")
    if space_count > 0 then
      text:append(string.rep(" ", space_count))
    end
    text:append(hint, "@variable.builtin")
    current_length = current_length + space_count + #hint
  end

  if #self.children > 0 then
    local space_count = text_width - current_length - 2
    assert(space_count >= 0, "space_count should be positive")
    if space_count > 0 then
      text:append(string.rep(" ", space_count))
    end
    text:append(" ▶")
  end

  return nui_menu.item(text, {
    menu_item = self,
  })
end

return MenuItem
