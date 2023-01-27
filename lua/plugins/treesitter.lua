return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPost',
    opts = {
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
      context_commentstring = { enable = true, enable_autocmd = false },

    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  },
  { 'RRethy/nvim-treesitter-endwise', lazy = true },
}
