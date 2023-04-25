local M = {
  Use {
    'iamcco/markdown-preview.nvim',
    lazy = {
      ft = { 'markdown' },
      lazy = true,
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      init = function()
        vim.g.mkdp_open_to_the_world = true
        vim.g.mkdp_echo_preview_url = true
      end,
    },
    category = 'MarkdownPreview',
    functions = {
      FuncSpec('Start markdown preview', 'MarkdownPreview'),
      FuncSpec('Stop markdown preview', 'MarkdownPreviewStop'),
      FuncSpec('Toggle markdown preview', 'MarkdownPreviewToggle'),
    },
  },
}

return M
