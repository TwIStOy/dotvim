---@type LazyPluginSpec
return {
  "akinsho/bufferline.nvim",
  version = "*",
  enabled = not vim.g.vscode,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          text_align = "left",
          separator = true,
        },
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "left",
          separator = true,
        },
      },
    },
    highlights = {
      buffer_selected = {
        bold = true,
      },
      indicator_selected = {
        fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
    },
  },
  keys = {
    { "<M-,>", "<cmd>BufferLineCyclePrev<cr>", desc = "prev-buffer" },
    { "<M-.>", "<cmd>BufferLineCycleNext<cr>", desc = "next-buffer" },
    { "<M-<>", "<cmd>BufferLineMovePrev<cr>", desc = "move-buffer-prev" },
    { "<M->>", "<cmd>BufferLineMoveNext<cr>", desc = "move-buffer-next" },
  },
}
