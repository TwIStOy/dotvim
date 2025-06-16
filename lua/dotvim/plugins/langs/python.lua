---@type LazyPluginSpec[]
return {
  {
    "monaqa/dial.nvim",
    ft = { "python" },
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
      
      opts.language_configs.python = {
        define_custom("True", "False"),
      }
      
      return opts
    end,
  },
}
