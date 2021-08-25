module('ht.plugs.vimwiki', package.seeall)

local set_g_var = vim.api.nvim_set_var
local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder

function setup()
  set_g_var('vimwiki_key_mappings', {global = 0})

  set_g_var('vimwiki_list', {{path = '~/Dropbox/vimwiki'}})

  local context_menu = {
    {'&Follow Link\t<cr>', 'VimwikiFollowLink'},
    {'&Split Link\t<S-cr>', 'VimwikiSplitLink'},
    {'&Back Link\t<Backspace>', 'VimwikiGoBackLink'},
    {'&Next Link\t<Tab>', 'VimwikiNextLink'},
    {'&Previous Link\t<S-Tab>', 'VimwikiPrevLink'}
  }
end

function config()
  require('ht.core.dropdown').AppendContext('vimwiki', context_menu)
end

