module('ht.conf.global', package.seeall)

-- all autocmds waiting for https://github.com/neovim/neovim/pull/12378
-- to register autocmd in lua natively

local va = vim.api
local cmd = vim.api.nvim_command
local keymap = va.nvim_set_keymap
local setopt = va.nvim_set_option

-- run impatient.nvim
require 'impatient'

require('ht.plugs.bufferline').setup()

cmd [[autocmd VimEnter * if !argc() | silent! Startify | endif]]

cmd [[autocmd BufEnter * lua require('ht.keymap.keymap').SetKeymapDescriptionToBuffer()]]

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

-- vim.opt.pumblend = 40

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

-- cursor settings
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor'

-- mouse mode
vim.opt.mouse = 'a'

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

-- jump options
vim.opt.jumpoptions = 'stack'

-- setup clipboard vis ssh, other settings: [[~/Dropbox/vimwiki/Remote Clipboard.wiki]]
if vim.fn.has('linux') == 1 then
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
end

-- skip specify types when switching windows
local ww = require('ht.core.window')
ww.Skip('quickfix')
ww.Skip('defx')
ww.Skip('CHADTree')
ww.Skip('NvimTree')

cmd [[au BufEnter * lua require('ht.core.window').CheckLastWindow() ]]

local SetFolderName = require('ht.keymap.keymap').SetFolderName
local nmap = require'ht.keymap.keymap'.nmap
local vmap = require'ht.keymap.keymap'.vmap
local xmap = require'ht.keymap.keymap'.xmap

nmap('<F3>', [[<cmd>lua require('ht.core.window').JumpToFileExplorer()<CR>]])
nmap('<C-n>', [[<cmd>HopLine<CR>]])
nmap('<F4>', '<cmd>call quickui#tools#list_buffer("e")<CR>')
nmap(';;', [[<cmd>lua require('ht.actions').OpenDropdown()<CR>]])
nmap('<leader><leader>', [[<cmd>lua require('ht.actions').OpenMenu()<cr>]])

for i = 1, 9 do
  nmap('<leader>' .. i,
       [[<cmd>lua require('ht.core.window').GotoWindow(]] .. i .. ')<CR>',
       {description = 'Window ' .. i})
end

SetFolderName('*', 'f', 'file')
nmap('<leader>fs', '<cmd>update<CR>', {description = 'update'})
nmap('<C-p>', [[<cmd>lua require('ht.actions.file').OpenProjectRoot()<CR>]])
nmap('<leader>e', [[<cmd>lua require('ht.actions.file').OpenProjectRoot()<CR>]],
     {description = 'edit-file-pwd'})

nmap('*', [[<cmd>call quickhl#manual#this_whole_word('n')<CR>]])
nmap('n', [[<cmd>call quickhl#manual#go_to_next('s')<CR>]])
nmap('N', [[<cmd>call quickhl#manual#go_to_prev('s')<CR>]])
nmap('<M-n>', [[:nohl<CR>:QuickhlManualReset<CR>]])
vmap('*', [[<cmd>call quickhl#manual#this('v')<CR>]])

nmap('<leader>q', '<cmd>q<CR>', {description = 'quit'})
nmap('<leader>x', '<cmd>wq<CR>', {description = 'save-and-quit'})
nmap('<leader>Q', '<cmd>confirm qall<CR>', {description = 'quit-all'})

nmap('tq', [[:lua require('ht.core.window').ToggleQuickfix()<CR>]])

SetFolderName('*', 'w', 'window')
nmap('<leader>wv', '<cmd>wincmd v<CR>', {description = 'split-window-vertical'})
nmap('<leader>w-', '<cmd>wincmd s<CR>',
     {description = 'split-window-horizontal'})
nmap('<leader>w=', '<cmd>wincmd =<CR>', {description = 'balance-window'})
nmap('<leader>wr', '<cmd>wincmd r<CR>',
     {description = 'rotate-window-rightwards'})
nmap('<leader>wx', '<cmd>wincmd x<CR>',
     {description = 'exchange-window-with-next'})

nmap('<M-h>', '<cmd>wincmd h<CR>')
nmap('<M-j>', '<cmd>wincmd j<CR>')
nmap('<M-k>', '<cmd>wincmd k<CR>')
nmap('<M-l>', '<cmd>wincmd l<CR>')
nmap('<M-b>', '<cmd>SidewaysLeft<CR>')
nmap('<M-f>', '<cmd>SidewaysRight<CR>')

-- whichkey
nmap('<leader>', [[:WhichKey '<Space>'<CR>]])

SetFolderName('*', 'v', 'vcs')
nmap('<leader>v1', '<cmd>call conflict_resolve#ourselves()<CR>',
     {description = 'select-ours'})
nmap('<leader>v2', '<cmd>call conflict_resolve#themselves()<CR>',
     {description = 'select-them'})
nmap('<leader>vb', '<cmd>call conflict_resolve#both()<CR>',
     {description = 'select-both'})

if vim.g['fvim_loaded'] == nil then
  vim.opt.wildoptions = 'pum'
end

SetFolderName('*', 't', 'table')
nmap('<leader>ta', '<cmd>EasyAlign<CR>', {description = 'easy-align'})
xmap('<leader>ta', '<cmd>EasyAlign<CR>')

-- add default menu section
require('ht.core.dropdown').AppendContext('*', {
  {'Move Object &Left', 'SidewaysLeft'}, {'Move Object &Right', 'SidewaysRight'}
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
nmap(',,', [[<cmd>HopWord<CR>]])
nmap(',l', [[<cmd>HopLine<CR>]])

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

-- gui: neovide
vim.g.neovide_refresh_rate = 144
vim.o.guifont = 'RecMonoHawtian Nerd Font:h14'

