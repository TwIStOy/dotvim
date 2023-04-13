local M = {
  'krivahtoo/silicon.nvim',
  build = './install.sh build',
  enabled = false,
  lazy = false,
  -- cmd = { 'Silicon' },
  opts = {
    font = 'Iosevka=16',
    theme = 'Monokai Extended',
    line_number = true,
    pad_vert = 80,
    pad_horiz = 50,
    output = { path = vim.fn.expand('~/Dropbox/Temp') },
    watermark = { text = '@Hawtian Wang' },
    window_title = function()
      return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ':~:.')
    end,
  },
  config = function(_, opts)
    require'silicon'.setup(opts)
  end,
}

return M
