module('dotvim.crate.default', package.seeall)

plugins = {
  { 'skywind3000/asyncrun.vim', { on_cmd = { 'AsyncRun', 'AsyncStop' } } },
  { 'mhinz/vim-startify', { on_cmd = { 'Startify' }, builtin_conf = 1 } },
  { 'Shougo/defx.nvim', { on_cmd = { 'Defx' }, builtin_conf = 1 } },
  'tpope/vim-vividchalk',
  { 'liuchengxu/vim-which-key', { on_cmd = { 'WhichKey', 'WhichKey!' }, builtin_conf = 1 } },
  'TwIStOy/multihighlight.nvim',
  'skywind3000/vim-quickui',
  { 'dstein64/vim-startuptime', { on_cmd = { 'StartupTime' } } }
}

function Config()
  -- startify
  vim.api.nvim_command('autocmd VimEnter * if !argc() | call dein#source("vim-startify") | silent! Startify | endif')
end

function PostConfig()
end

