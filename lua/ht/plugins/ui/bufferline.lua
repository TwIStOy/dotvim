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
      -- local mocha = require("catppuccin.palettes").get_palette("mocha")
      local opts = {
        -- highlights = require("catppuccin.groups.integrations.bufferline").get {
        --   styles = { "italic", "bold" },
        --   custom = {
        --     all = {
        --       fill = { bg = "#000000" },
        --     },
        --     mocha = {
        --       background = { fg = mocha.text },
        --     },
        --     latte = {
        --       background = { fg = "#000000" },
        --     },
        --   },
        -- },
        options = {
          view = "multiwindow",
          sort_by = "insert_after_current",
          always_show_bufferline = true,
          themable = true,
          right_mouse_command = nil,
          middle_mouse_command = "bdelete! %d",
          indicator = {
            style = "bold",
          },
          hover = { enabled = true, delay = 200 },
          separator_style = "slant",
          close_command = "BDelete! %d",
          numbers = "none",
          diagnostics = "",
          show_buf_icons = false,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              highlight = "Directory",
            },
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              highlight = "Directory",
            },
          },
          groups = {
            options = {
              toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
            },
            items = {
              {
                name = "Tests", -- Mandatory
                priority = 2, -- determines where it will appear relative to other groups (Optional)
                icon = "", -- Optional
                matcher = function(buf) -- Mandatory
                  return buf.name:match("%_test") or buf.name:match("%_spec")
                end,
              },
            },
          },
        },
      }
      require("bufferline").setup(opts)
    end,
  },
}
