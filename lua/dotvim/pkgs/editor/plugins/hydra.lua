---@type dotvim.core.plugin.PluginOption
return {
  "nvimtools/hydra.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local hydra = require("hydra")

    hydra.setup(opts)

    require("dotvim.extra.hydra").create_hydras()
  end
}
