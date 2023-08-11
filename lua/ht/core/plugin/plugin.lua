---@class ht.core.plugin.Plugin
---@field short_url string
---@field lazy_plug_spec LazyPluginSpec
local Plugin = {}

---@param opts LazyPluginSpec|fun(): LazyPluginSpec
function Plugin:lazy_opts(opts)
  if type(opts) == "function" then
    opts = opts()
  end
  self.lazy_plug_spec = vim.tbl_extend("force", self.lazy_plug_spec, opts)
end

local M = {}
return setmetatable(M, {
  ---@param name string
  ---@return ht.core.plugin.Plugin
  __call = function(name)
    local o = {
      short_url = name,
      lazy_plug_spec = {},
    }
    setmetatable(o, { __index = Plugin })
    return o
  end,
})
