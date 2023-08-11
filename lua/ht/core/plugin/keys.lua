---@class ht.plugins.keys.Key
---@field lhs string left-hand side {lhs} of the mapping
---@field mode string|string[]|nil mode short-name
local Key = {}

---@alias ht.plugins.keys.Keys string|string[]|ht.plugins.keys.Key|ht.plugins.keys.Key[]

---@param rhs string|function
---@param opts table?
function Key:setup(rhs, opts)
  local mode = self.mode or "n"
  vim.keymap.set(mode, self.lhs, rhs, opts)
end

return {
  Key = Key,
}
