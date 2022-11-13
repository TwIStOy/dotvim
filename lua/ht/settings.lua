local M = {}

local mapping = require 'ht.core.mapping'
local event = require 'ht.core.event'
local import = require'ht.utils.import'.import

-- run impatient.nvim
require 'impatient'

vim.api.nvim_set_var('mapleader', ' ')

-- Disable arrows
vim.api.nvim_set_keymap('', '<Left>', '<Nop>', {})
vim.api.nvim_set_keymap('', '<Right>', '<Nop>', {})
vim.api.nvim_set_keymap('', '<Up>', '<Nop>', {})
vim.api.nvim_set_keymap('', '<Down>', '<Nop>', {})

vim.opt.title = true
vim.opt.ttyfast = true

vim.opt.lazyredraw = false
vim.opt.termguicolors = true

vim.opt.updatetime = 200

-- no bells
vim.cmd [[set noerrorbells novisualbell t_vb=]]

-- numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.relative_number_blacklist = { 'startify', 'NvimTree', 'packer', 'alpha' }

event.on('TermEnter', { pattern = '*', command = 'setlocal nonu nornu' })
event.on({ 'BufEnter', 'FocusGained', 'WinEnter' }, {
  pattern = '*',
  command = 'if index(g:relative_number_blacklist, &ft) == -1 | set nu rnu | endif',
})
event.on({ 'BufLeave', 'FocusLost', 'WinLeave' }, {
  pattern = '*',
  command = 'if index(g:relative_number_blacklist, &ft) == -1 | set nu nornu | endif',
})

vim.opt.cursorline = true
event.on({ 'InsertLeave', 'WinEnter' },
         { pattern = '*', command = 'set cursorline' })
event.on({ 'InsertEnter', 'WinLeave' },
         { pattern = '*', command = 'set nocursorline' })

-- cursor settings
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor'

-- mouse mode
vim.opt.mouse = 'a'

-- statusline
vim.opt.laststatus = 3

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
event.on('FileType', { pattern = 'qf', command = 'wincmd J' })

-- default colorcolumn: 80
vim.opt.colorcolumn = '80'

vim.opt.scrolloff = 5

vim.opt.timeoutlen = 300

vim.opt.signcolumn = 'yes'
event.on({ 'BufEnter', 'FocusGained', 'WinEnter' },
         { pattern = '*', command = 'set signcolumn=yes' })

vim.opt.hidden = true

-- jump options
vim.opt.jumpoptions = 'stack'

-- setup clipboard vis ssh, other settings: [[~/Dropbox/vimwiki/Remote Clipboard.wiki]]
if vim.fn.has('linux') == 1 then
  local copy_settings = {}
  copy_settings['+'] = { 'nc', 'localhost', '2224', '-w0' }
  copy_settings['*'] = { 'nc', 'localhost', '2224', '-w0' }
  local paste_settings = {}
  paste_settings['+'] = { 'nc', 'localhost', '2225', '-w1' }
  paste_settings['*'] = { 'nc', 'localhost', '2225', '-w1' }
  vim.g.clipboard = {
    name = 'ssh-remote-clip',
    copy = copy_settings,
    paste = paste_settings,
    cache_enabled = 1,
  }
end

require'ht.core.window'.skip_filetype('quickfix')
require'ht.core.window'.skip_filetype('defx')
require'ht.core.window'.skip_filetype('CHADTree')
require'ht.core.window'.skip_filetype('NvimTree')

event.on('BufEnter', {
  pattern = '*',
  callback = function()
    require'ht.core.window'.check_last_window()
  end,
})

mapping.map { keys = { '<M-h>' }, action = '<cmd>wincmd h<CR>' }
mapping.map { keys = { '<M-j>' }, action = '<cmd>wincmd j<CR>' }
mapping.map { keys = { '<M-k>' }, action = '<cmd>wincmd k<CR>' }
mapping.map { keys = { '<M-l>' }, action = '<cmd>wincmd l<CR>' }
mapping.map { keys = { '<M-b>' }, action = '<cmd>SidewaysLeft<CR>' }
mapping.map { keys = { '<M-f>' }, action = '<cmd>SidewaysRight<CR>' }

mapping.append_folder_name({ '<leader>', 'w' }, 'window')
mapping.map {
  keys = { '<leader>', 'w', 'v' },
  action = '<cmd>wincmd v<CR>',
  desc = 'split-window-vertical',
}
mapping.map {
  keys = { '<leader>', 'w', '-' },
  action = '<cmd>wincmd s<CR>',
  desc = 'split-window-horizontal',
}
mapping.map {
  keys = { '<leader>', 'w', '=' },
  action = '<cmd>wincmd =<CR>',
  desc = 'balance-window',
}
mapping.map {
  keys = { '<leader>', 'w', 'r' },
  action = '<cmd>wincmd r<CR>',
  desc = 'rotate-window-rightwards',
}
mapping.map {
  keys = { '<leader>', 'w', 'x' },
  action = '<cmd>wincmd x<CR>',
  desc = 'exchange-window-with-next',
}

for i = 1, 9 do
  mapping.map {
    keys = { '<leader>', '' .. i },
    action = function()
      require'ht.core.window'.goto_window(i)
    end,
    desc = 'goto-win-' .. i,
  }
  mapping.map {
    keys = { ',', '' .. i },
    action = function()
      require'ht.core.window'.goto_window(i)
    end,
    desc = 'goto-win-' .. i,
  }
end

mapping.append_folder_name({ '<leader>', 'f' }, 'file')
mapping.map {
  keys = { '<leader>', 'f', 's' },
  action = '<cmd>update<CR>',
  desc = 'update',
}

mapping.map { keys = { '<F2>' }, action = '<cmd>w<CR>' }
mapping.map { keys = { '<S-F2>' }, action = '<cmd>wall<CR>' }

mapping.map { keys = { '<leader>', 'q' }, action = '<cmd>q<CR>', desc = 'quit' }
mapping.map {
  keys = { '<leader>', 'Q' },
  action = '<cmd>confirm qall<CR>',
  desc = 'quit-all',
}

mapping.map {
  keys = { 't', 'q' },
  action = function()
    require'ht.core.window'.toggle_quickfix()
  end,
  desc = 'toggle-quickfix',
}

if vim.g['fvim_loaded'] == nil then
  vim.opt.wildoptions = 'pum'
end

-- gui: neovide
if vim.g["neovide"] then
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.o.guifont = 'JetBrainsMono Nerd Font:h14'
end

-- def ft-related settings
mapping.ft_map('cpp', {
  keys = { '<leader>', 'n', 'c' },
  desc = 'copy-function-decl',
  action = function()
    require('ht.features.cpp.copy_decl').copy_declare()
  end,
})
mapping.ft_map('cpp', {
  keys = { '<leader>', 'n', 'c' },
  desc = 'copy-function-decl',
  mode = 'v',
  action = [[:lua require'ht.features.cpp.copy_decl'.copy_declare_from_selection()<CR>]],
})
mapping.ft_map('cpp', {
  keys = { '<leader>', 'n', 'p' },
  desc = 'generate-function-defination',
  action = function()
    require('ht.features.cpp.copy_decl').generate_at_cursor()
  end,
})

return M
