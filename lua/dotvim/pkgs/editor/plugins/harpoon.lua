---@type dotvim.core.plugin.PluginOption
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "plenary.nvim",
  },
  keys = function()
    local harpoon = require("harpoon")
    return {
      {
        "<C-m>",
        function()
          harpoon:list():add()
        end,
      },
      {
        "<C-o>",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end
      }
    }
  end,
  opts = { settings = { save_on_toggle = true } },
  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)
  end,
}
