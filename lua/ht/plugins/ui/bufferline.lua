return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    keys = {
      { "<M-,>", "<cmd>BufferLineCyclePrev<CR>" },
      { "<M-.>", "<cmd>BufferLineCycleNext<CR>" },
      { "<M-<>", "<cmd>BufferLineMovePrev<CR>" },
      { "<M->>", "<cmd>BufferLineMoveNext<CR>" },
    },
    config = function()
      vim.defer_fn(function()
        local mocha = require("catppuccin.palettes").get_palette("mocha")
        local opts = {
          highlights = require("catppuccin.groups.integrations.bufferline").get {
            styles = { "italic", "bold" },
            custom = {
              all = {
                fill = { bg = "#000000" },
              },
              mocha = {
                background = { fg = mocha.text },
              },
              latte = {
                background = { fg = "#000000" },
              },
            },
          },
          options = {
            view = "multiwindow",
            sort_by = "insert_after_current",
            always_show_bufferline = true,
            themable = true,
            hover = { enabled = true, delay = 200 },
            separator_style = "slant",
            close_command = "BDelete! %d",
            numbers = "none",
            diagnostics = "nvim_lsp",
            indicator = {
              style = "bold",
            },
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                highlight = "Directory",
              },
            },
          },
        }
        require("bufferline").setup(opts)
      end, 20)
    end,
  },
}
