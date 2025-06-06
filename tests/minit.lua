if os.getenv('TEST_COV') then
  require('luacov')
end

-- Add plenary.nvim to runtime path
local plenary_path = vim.fn.stdpath('cache') .. '/test-deps/plenary.nvim'
if vim.fn.isdirectory(plenary_path) == 0 then
  vim.fn.system({
    'git', 'clone', '--depth=1',
    'https://github.com/nvim-lua/plenary.nvim.git',
    plenary_path
  })
end
vim.opt.rtp:prepend(plenary_path)

vim.opt.swapfile = false

