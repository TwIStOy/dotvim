---@type LazyPluginSpec[]
return {
  {
    "monaqa/dial.nvim",
    ft = { "toml" },
    opts = function(_, opts)
      local augend = require("dial.augend")

      opts = opts or {}
      opts.language_configs = opts.language_configs or {}
      
      opts.language_configs.toml = {
        augend.semver.alias.semver,
      }
      
      return opts
    end,
  },
}