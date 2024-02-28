---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.misc.copilot",
  deps = {
    "dora.packages.coding",
  },
  plugins = {
    {
      "zbirenbaum/copilot.lua",
      event = "InsertEnter",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
          },
        },
      },
      config = function(_, opts)
        vim.defer_fn(function()
          require("copilot").setup(opts)
        end, 100)
      end,
      actions = function()
        return {
          {
            id = "copilot.status",
            title = "Copilot status",
            description = "Show the status of Copilot",
            callback = function()
              vim.api.nvim_command("Copilot status")
            end,
          },
          {
            id = "copilot.auth",
            title = "Copilot auth",
            callback = function()
              vim.api.nvim_command("Copilot auth")
            end,
          },
          {
            id = "copilot.show-panel",
            title = "Copilot panel",
            callback = function()
              vim.api.nvim_command("Copilot panel")
            end,
          },
        }
      end,
    },
  },
}
