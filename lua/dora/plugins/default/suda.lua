local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "lambdalisue/suda.vim",
  cmd = {
    "SudaRead",
    "SudaWrite",
  },
  init = function()
    vim.g["suda#nopass"] = 1
  end,
  actions = lib.plugin.action.make_options {
    from = "suda.vim",
    category = "suda",
    actions = {
      {
        id = "suda.read",
        title = "Read file with sudo",
        callback = "SudaRead",
      },
      {
        id = "suda.write",
        title = "Write file with sudo",
        callback = "SudaWrite",
      },
    },
  },
}
