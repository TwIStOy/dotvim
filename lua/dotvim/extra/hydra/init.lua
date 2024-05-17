---@class dotvim.extra.hydra
local M = {}

---@type dotvim.extra.hydra.utils
M.Utils = require("dotvim.extra.hydra.utils")

---@type dotvim.utils
local Utils = require("dotvim.utils")

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

M.hydras = {}

local hydra_names = {
  "bufferline",
  "window",
  "git-conflict",
}

M.create_hydras = Utils.fn.invoke_once(function()
  for _, name in ipairs(hydra_names) do
    M.hydras[name] = M.load_my_hydra(name)
  end
  return nil
end)

return M
