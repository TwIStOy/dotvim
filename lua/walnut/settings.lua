module('walnut.settings', package.seeall)

-- all autocmds waiting for https://github.com/neovim/neovim/pull/12378
-- to register autocmd in lua natively

local va = vim.api
local cmd = vim.api.nvim_command
local keymap = va.nvim_set_keymap
local setopt = va.nvim_set_option

cmd [[autocmd VimEnter * if !argc() | silent! Startify | endif]]

cmd [[autocmd BufEnter * lua require('walnut.keymap').define_keymap_here()]]

va.nvim_set_var('mapleader', ' ')

-- Disable arrows
keymap('', '<Left>', '<Nop>', {})
keymap('', '<Right>', '<Nop>', {})
keymap('', '<Up>', '<Nop>', {})
keymap('', '<Down>', '<Nop>', {})

vim.opt.title = true
vim.opt.ttyfast = true

vim.opt.lazyredraw = false
vim.opt.termguicolors = true

vim.opt.pumblend = 40

vim.opt.updatetime = 200

-- no bells
cmd [[set noerrorbells novisualbell t_vb=]]

-- numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.relative_number_blacklist = {'startify', 'NvimTree', 'packer'}
cmd [[autocmd TermEnter * setlocal nonu nornu]]
cmd [[autocmd BufEnter,FocusGained,WinEnter * if index(g:relative_number_blacklist, &ft) == -1 | set nu rnu | endif]]
cmd [[autocmd BufLeave,FocusLost,WinLeave * if index(g:relative_number_blacklist, &ft) == -1 | set nu nornu | endif]]

-- cursorline autocmd
vim.opt.cursorline = true
cmd('autocmd InsertLeave,WinEnter * set cursorline')
cmd('autocmd InsertEnter,WinLeave * set nocursorline')

-- edit settings
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- default tab width: 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.showmode = false
vim.opt.cmdheight = 2

vim.opt.exrc = true

-- move quickfix windows to botright automatically
cmd('autocmd FileType qf wincmd J')

-- default colorcolumn: 80
vim.opt.colorcolumn = '80'

vim.opt.scrolloff = 5

vim.opt.timeoutlen = 300

vim.opt.signcolumn = 'yes'
cmd [[autocmd BufEnter,FocusGained,WinEnter set signcolumn=yes]]

vim.opt.hidden = true

-- theme settings
vim.opt.background = 'dark'

-- jump options
vim.opt.jumpoptions = 'stack'

-- setup clipboard vis ssh, other settings: [[~/Dropbox/vimwiki/Remote Clipboard.wiki]]
local copy_settings = {}
copy_settings['+'] = {'nc', 'localhost', '2224', '-w0'}
copy_settings['*'] = {'nc', 'localhost', '2224', '-w0'}
local paste_settings = {}
paste_settings['+'] = {'nc', 'localhost', '2225', '-w1'}
paste_settings['*'] = {'nc', 'localhost', '2225', '-w1'}
vim.g.clipboard = {
  name = 'ssh-remote-clip',
  copy = copy_settings,
  paste = paste_settings,
  cache_enabled = 1
}

-- skip specify types when switching windows
local ww = require('walnut.window')
ww.skip_type('quickfix')
ww.skip_type('defx')
ww.skip_type('CHADTree')
ww.skip_type('NvimTree')

cmd [[au BufEnter * lua require('walnut.window').check_last_window() ]]

local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder

keymap('n', '<F3>',
       [[:lua require('walnut.window').fast_forward_to_file_explorer()<CR>]],
       {silent = true, noremap = true})
keymap('n', '<C-n>',
       [[:lua require('walnut.window').fast_forward_to_file_explorer()<CR>]],
       {silent = true, noremap = true})
keymap('n', '<F4>', ':call quickui#tools#list_buffer("e")<CR>',
       {silent = true, noremap = true})
keymap('n', ';;',
       [[:lua require('walnut.pcfg.quickui').open_dropdown_menu(vim.api.nvim_buf_get_option(0, 'ft'))<CR>]],
       {silent = true, noremap = true})
keymap('n', '<leader><leader>',
       [[:lua require('walnut.pcfg.quickui').open_top_menu()<CR>]],
       {silent = true, noremap = true})

for i = 1, 9 do
  ftmap('*', 'Window ' .. i, '' .. i,
        [[:lua require('walnut.window').goto_win(]] .. i .. ')<CR>')
end

ftdesc_folder('*', 'f', 'file')
ftmap('*', 'update', 'fs', ':update<CR>')
ftmap('*', 'toggle-file-explorer', 'ft',
      [[:lua require('walnut.window').fast_forward_to_file_explorer()<CR>]])
keymap('n', '<C-p>',
       [[<cmd>lua require('ht.plugs.telescope').OpenProjectRoot()<CR>]],
       {noremap = true, silent = true})
ftmap('*', 'edit-file-pwd', 'e',
      [[<cmd>lua require('ht.plugs.telescope').OpenProjectRoot()<CR>]])


keymap('n', '*', [[<cmd>call quickhl#manual#this_whole_word('n')<CR>]],
       {silent = true, noremap = true})
keymap('n', 'n', [[<cmd>call quickhl#manual#go_to_next('s')<CR>]],
       {silent = true, noremap = true})
keymap('n', 'N', [[<cmd>call quickhl#manual#go_to_prev('s')<CR>]],
       {silent = true, noremap = true})
keymap('n', '<M-n>', [[:nohl<CR>:QuickhlManualReset<CR>]],
       {silent = true, noremap = true})
keymap('v', '*', [[<cmd>call quickhl#manual#this('v')<CR>]],
       {silent = true, noremap = true})

ftmap('*', 'quit', 'q', ':q<CR>')
ftmap('*', 'save-and-quit', 'x', ':wq<CR>')
ftmap('*', 'quit-all', 'Q', ':confirm qall<CR>')

keymap('n', 'tq', [[:lua require('walnut.window').toggle_quickfix()<CR>]],
       {silent = true, noremap = true})

ftdesc_folder('*', 'w', 'window')
ftmap('*', 'split-window-vertical', 'wv', ':wincmd v<CR>')
ftmap('*', 'split-window-horizontal', 'w-', ':wincmd s<CR>')
ftmap('*', 'balance-window', 'w=', ':wincmd =<CR>')
ftmap('*', 'rotate-window-rightwards', 'wr', ':wincmd r<CR>')
ftmap('*', 'exchange-window-with-next', 'wx', ':wincmd x<CR>')

keymap('n', '<M-h>', ':wincmd h<CR>', {silent = true, noremap = true})
keymap('n', '<M-j>', ':wincmd j<CR>', {silent = true, noremap = true})
keymap('n', '<M-k>', ':wincmd k<CR>', {silent = true, noremap = true})
keymap('n', '<M-l>', ':wincmd l<CR>', {silent = true, noremap = true})
keymap('n', '<M-b>', ':SidewaysLeft<CR>', {silent = true, noremap = true})
keymap('n', '<M-f>', ':SidewaysRight<CR>', {silent = true, noremap = true})

keymap('n', '<leader>', [[:WhichKey '<Space>'<CR>]],
       {silent = true, noremap = true})

ftdesc_folder('*', 'v', 'vcs')
ftmap('*', 'select-ours', 'v1', ':call conflict_resolve#ourselves()<CR>')
ftmap('*', 'select-them', 'v2', ':call conflict_resolve#themselves()<CR>')
ftmap('*', 'select-both', 'vb', ':call conflict_resolve#both()<CR>')
ftmap('*', 'show-commit', 'vm', ':CocCommand git.showCommit<CR>')

if vim.g['fvim_loaded'] == nil then
  vim.opt.wildoptions = 'pum'
end

ftmap('*', 'easy-align', 'ta', ':EasyAlign<CR>')
vim.api.nvim_set_keymap('x', '<leader>ta', ':EasyAlign<CR>', {silent = true})

-- add default menu section
require('walnut.pcfg.quickui').append_context_menu_section('*', {
  {'Move Object Left', 'SidewaysLeft'}, {'Move Object Right', 'SidewaysRight'}
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'c', 'cpp', 'toml', 'python', 'rust', 'go', 'typescript', 'lua'
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {} -- list of language that will be disabled
  }
}

-- keymappings for hop
keymap('n', ',,', [[<cmd>HopWord<CR>]], {silent = true, noremap = true})
keymap('n', ',l', [[<cmd>HopLine<CR>]], {silent = true, noremap = true})

vim.notify = function(msg, ...)
  local res = ''
  local first = true
  for str in string.gmatch(msg, "([^\n]+)") do
    if first then
      first = false
    else
      res = res .. '\n'
    end
    res = res .. ' ' .. str
  end

  require('notify')(res, ...)
end

