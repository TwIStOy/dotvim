return {
  -- noicer ui
  {
    "folke/noice.nvim",
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
}
