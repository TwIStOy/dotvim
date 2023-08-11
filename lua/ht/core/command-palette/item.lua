---@diagnostic disable: return-type-mismatch, param-type-mismatch

---@class ht.command_palette.ItemOpts
---@field public title string|fun():string
---@field public category string|fun():string
---@field public description string|string[]|fun():string[]|nil
---@field public action fun()
---@field public enabled fun(buf: VimBuffer):boolean
---@field public dynamic boolean whether this item can be cahed
---@field public keys string|string[]|nil

---@class ht.command_palette.Item: ht.command_palette.ItemOpts
local Item = {}

---Returns search text used in Telescope
---@return string
function Item:get_search_text()
  return self.category .. self.title
end

---@return string
function Item:display_keys()
  if self.keys == nil then
    return ""
  elseif type(self.keys) == "string" then
    return self.keys
  else
    return table.concat(self.keys, ", ")
  end
end

---@return string[]?
function Item:display_description()
  if self.description == nil then
    return nil
  elseif type(self.description) == "string" then
    return { self.description }
  elseif type(self.description) == "function" then
    return self.description()
  else
    return self.description
  end
end

---@return string
function Item:display_category()
  if type(self.category) == "function" then
    return self.category()
  else
    return self.category
  end
end

---@return string
function Item:display_title()
  if type(self.title) == "function" then
    return self.title()
  else
    return self.title
  end
end

---@param opts table
function Item.validate(opts)
  vim.validate {
    title = { opts.title, { "s", "f" } },
    category = { opts.category, { "s", "f" } },
    description = { opts.description, { "s", "t", "f" }, true },
    action = { opts.action, "f" },
    enabled = { opts.enabled, "f" },
    dynamic = { opts.dynamic, "b" },
    keys = { opts.keys, { "s", "t" }, true },
  }
end

---@param opts ht.command_palette.ItemOpts
---@return ht.command_palette.Item
function Item.new(opts)
  local o = vim.tbl_deep_extend("force", {}, opts)
  setmetatable(o, { __index = Item })
  return o
end

return Item

