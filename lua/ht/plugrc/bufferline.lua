return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<M-,>', '<cmd>BufferLineCyclePrev<CR>' },
      { '<M-.>', '<cmd>BufferLineCycleNext<CR>' },
      { '<M-<>', '<cmd>BufferLineMovePrev<CR>' },
      { '<M->>', '<cmd>BufferLineMoveNext<CR>' },
    },
    config = function()
      require'bufferline'.setup {
        options = {
          view = 'multiwindow',
          highlights = require("catppuccin.groups.integrations.bufferline").get(),
          hover = { enabled = true, delay = 200 },
          separator_style = 'thin',
          close_command = "Bdelete! %d",
          numbers = function(opts)
            return string.format('%s¬∑%s', opts.raise(opts.id),
                                 opts.lower(opts.ordinal))
          end,
          diagnostics = 'nvim_lsp',
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              highlight = 'Directory',
            },
          },
        },
      }
    end,
  },
}
