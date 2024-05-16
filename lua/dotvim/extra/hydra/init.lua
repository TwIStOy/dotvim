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

local function fold_dydra_opts()
  return {
    body = "<leader>z",
    mode = { "n" },
    config = {
      color = "pink",
      hint = {
        type = "window",
        position = "middle",
        show_name = true,
      },
      invoke_on_body = true,
    },
    heads = {
      { "<Esc>", nil, { exit = true } },
      {
        "R",
        function()
          require("ufo").openAllFolds()
        end,
        { silent = true, nowait = true, exit = true, desc = "Open all folds" },
      },
    },
  }
end

function M.create_hydras()
  M.create_hydra(require("dotvim.extra.hydra.bufferline"))
end

return M
