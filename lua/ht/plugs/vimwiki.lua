module('ht.plugs.vimwiki', package.seeall)

local set_g_var = vim.api.nvim_set_var

function setup()
  vim.g.vimwiki_key_mappings = {global = 0}
  vim.g.vimwiki_list = {{path = '~/Dropbox/vimwiki'}}
end

function config()
  local context_menu = {
    {'&Follow Link\t<cr>', 'VimwikiFollowLink'},
    {'&Split Link\t<S-cr>', 'VimwikiSplitLink'},
    {'&Back Link\t<Backspace>', 'VimwikiGoBackLink'},
    {'&Next Link\t<Tab>', 'VimwikiNextLink'},
    {'&Previous Link\t<S-Tab>', 'VimwikiPrevLink'}
  }

  require('ht.core.dropdown').AppendContext('vimwiki', context_menu)
end

