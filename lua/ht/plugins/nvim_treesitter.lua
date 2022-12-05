local M = {}

M.core = {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    {
      'nvim-treesitter/playground',
      cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    },
    { 'RRethy/nvim-treesitter-endwise', opt = true, after = 'nvim-treesitter' },
  },
  event = { 'BufReadPost' },
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
      'html',
      'javascript',
      'typescript',
      'latex',
      'cmake',
      'css',
      'fish',
      'make',
      'proto',
      'markdown',
      'markdown_inline',
      'vim',
      'bash',
      'regex',
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

