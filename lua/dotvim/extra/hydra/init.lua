---@class dotvim.extra.hydra
local M = {}

---@type dotvim.extra.hydra.utils
M.Utils = require("dotvim.extra.hydra.utils")

---@class dotvim.extra.hydra.CreateHydraOpts
---@field heads table<string, hydra.Head|string|function>

---@param opts dotvim.extra.hydra.CreateHydraOpts
---@return Hydra
function M.create_hydra(opts)
  local Hydra = require("hydra")
  opts.heads = M.Utils.normalize_heads(opts.heads)
  return Hydra(opts)
end

function M.load_my_hydra(name)
  local module_name = ("dotvim.extra.hydra.hydras.%s"):format(name)
  return M.create_hydra(require(module_name))
end

function M.create_hydras()
  M.load_my_hydra("bufferline")
end

return M
