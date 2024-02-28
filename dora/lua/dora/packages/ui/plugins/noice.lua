---@type dora.core.plugin.PluginOption[]
return {
  {
    "folke/noice.nvim",
    event = { "ModeChanged", "BufReadPre", "InsertEnter" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        progress = { enabled = false, throttle = 1000 / 10 },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
        hover = {
          enabled = true,
          opts = {
            border = { style = "none", padding = { 1, 2 } },
            position = { row = 2, col = 2 },
          },
        },
      },
      messages = { enabled = false },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "noice.nvim",
        category = "Noice",
        actions = {
          {
            id = "noice.show-message-history",
            title = "Shows the message history",
            callback = "Noice history",
          },
          {
            id = "noice.show-last-message",
            title = "Shows the last message in a popup",
            callback = "Noice last",
          },
          {
            id = "noice.dismiss-all-messages",
            title = "Dismiss all visible messages",
            callback = "Noice dismiss",
          },
          {
            id = "noice.disable",
            title = "Disables Noice",
            callback = "Noice disable",
          },
          {
            id = "noice.enable",
            title = "Enables Noice",
            callback = "Noice enable",
          },
          {
            id = "noice.show-stats",
            title = "Show debugging stats",
            callback = "Noice stats",
          },
          {
            id = "noice.show-message-history-in-telescope",
            title = "Opens message history in Telescope",
            callback = "Noice telescope",
          },
          {
            id = "noice.show-errors",
            title = "Shows the error messages in a split",
            callback = "Noice errors",
          },
        },
      }
    end,
  },
}
