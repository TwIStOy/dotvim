---@type LazyPluginSpec[]
return {
  {
    "monaqa/dial.nvim",
    ft = { "cmake" },
    opts = function(_, opts)
      local augend = require("dial.augend")
      
      local function define_custom(...)
        return augend.constant.new {
          elements = { ... },
          word = true,
          cyclic = true,
        }
      end

      opts = opts or {}
      opts.language_configs = opts.language_configs or {}
      
      opts.language_configs.cmake = {
        define_custom("on", "off"),
        define_custom("ON", "OFF"),
      }
      
      return opts
    end,
  },
}
