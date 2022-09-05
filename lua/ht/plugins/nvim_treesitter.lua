local M = {}

M.core = {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    {
      'nvim-treesitter/playground',
      cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    },
    'RRethy/nvim-treesitter-endwise',
  },
}

M.config = function() -- code to run after plugin loaded
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      'c',
      'cpp',
      'toml',
      'python',
      'rust',
      'go',
      'typescript',
      'lua',
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {}, -- list of language that will be disabled
    },
    endwise = { enable = true },
  }
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

