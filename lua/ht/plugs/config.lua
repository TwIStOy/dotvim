module('ht.plugs.config', package.seeall)

function surround()
  vim.g.surround_no_mappings = 0
  vim.g.surround_no_insert_mappings = 1
end

function treesitter()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      'c', 'cpp', 'toml', 'python', 'rust', 'go', 'typescript', 'lua'
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {} -- list of language that will be disabled
    }
  }
end

function tcomment()
  vim.api.nvim_set_keymap('n', 'gcc', ':TComment<CR>',
                          {silent = true, noremap = true})
  vim.api.nvim_set_keymap('v', 'gcc', ':TCommentBlock<CR>',
                          {silent = true, noremap = true})
end

function vim_jplus()
  vim.api.nvim_set_keymap('n', 'J', '<Plug>(jplus)', {silent = true})
  vim.api.nvim_set_keymap('v', 'J', '<Plug>(jplus)', {silent = true})
end

-- vim: et sw=2 ts=2

