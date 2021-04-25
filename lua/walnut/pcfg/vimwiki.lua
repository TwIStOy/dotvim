module('walnut.pcfg.vimwiki', package.seeall)

local set_g_var = vim.api.nvim_set_var
local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder

set_g_var('vimwiki_key_mappings', {
  global = 0,
})

set_g_var('vimwiki_list', {
  {
    path = '~/Dropbox/vimwiki',
  }
})

function config()
  local wiki_menu = {
    { '&Open Index', 'VimwikiIndex' },
    { 'Open Index(new &tab)', 'VimwikiTabIndex' },
    { '&Select', 'VimwikiUISelect' },
    { '--', '' },
    { 'Open &Diary Index', 'VimwikiDiaryIndex' },
    { '&Crate Diary Note', 'VimwikiMakeDiaryNote' },
  }

  vim.api.nvim_call_function('quickui#menu#install', {
    '&Wiki', wiki_menu
  })
end

