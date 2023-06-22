return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<M-,>", "<cmd>BufferLineCyclePrev<CR>" },
      { "<M-.>", "<cmd>BufferLineCycleNext<CR>" },
      { "<M-<>", "<cmd>BufferLineMovePrev<CR>" },
      { "<M->>", "<cmd>BufferLineMoveNext<CR>" },
    },
    opts = {
      options = {
        view = "multiwindow",
        sort_by = "insert_after_current",
        always_show_bufferline = false,
        themable = true,
        hover = { enabled = true, delay = 200 },
        separator_style = "slant",
        close_command = "BDelete! %d",
        numbers = "none",
        diagnostics = "nvim_lsp",
        indicator = {
          style = "underline",
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
    },
    config = function(_, opts)
      vim.defer_fn(function()
        require("bufferline").setup(opts)
      end, 20)
    end,
  },
}
