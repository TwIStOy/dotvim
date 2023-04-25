return {
  -- noicer ui
  Use {
    "folke/noice.nvim",
    lazy = {
      lazy = true,
      event = "VeryLazy",
      dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
      enabled = function()
        if vim.g["neovide"] then
          return false
        end
        return true
      end,
      opts = {
        lsp = {
          progress = { enabled = false, throttle = 1000 / 10 },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        messages = { enabled = false },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      },
      config = function(_, opts)
        vim.defer_fn(function()
          require("noice").setup(opts)
        end, 20)
      end,
    },
    functions = {
      FuncSpec("Shows the message history", "Noice history"),
      FuncSpec("Shows the last message in a popup", "Noice last"),
      FuncSpec("Dismiss all visible messages", "Noice dismiss"),
      FuncSpec("Disables Noice", "Noice disable"),
      FuncSpec("Enables Noice", "Noice enable"),
      FuncSpec("Show debugging stats", "Noice stats"),
      FuncSpec("Opens message history in Telescope", "Noice telescope"),
      FuncSpec("Shows the error messages in a split", "Noice errors"),
    },
  },
}
