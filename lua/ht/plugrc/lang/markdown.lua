local M = {
  {
    'iamcco/markdown-preview.nvim',
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
}

return M
