local U = require 'ht.utils.init'
local is_type = U.is_type
local normalize_vec_str = U.normalize_vec_str

---@class PluginSpec
---@field short_url string|nil
---@field lazy table all options passed to lazy.nvim
---@field functionalities PluginFunctionalitySpec[]
local PluginSpec = {}

function PluginSpec:as_lazy_spec()
  local spec = {}
  -- short url
  spec[1] = self.short_url or self[1]

  return spec
end
