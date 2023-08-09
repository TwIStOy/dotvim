---@class ht.utils.LazyModuleOpts
---@field name string
---@field try_private_sub boolean?

---@param opts ht.utils.LazyModuleOpts
---@return table
local function make_lazy_module(opts)
  local M = {}
  setmetatable(M, {
    __index = function(table, key)
      local submod_name = key
      local submod
      if opts.try_private_sub == true then
        local private_submod_name = "_" .. submod_name
        submod = require(opts.name .. "." .. private_submod_name)
      end
      if submod == nil then
        submod = require(opts.name .. "." .. submod_name)
      end
      if submod == nil then
        error("module " .. opts.name .. "." .. submod_name .. " not found")
      end
      rawset(table, key, submod)
      return submod
    end,
  })
  return M
end

return make_lazy_module
