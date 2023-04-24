return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    build = function()
      if #vim.api.nvim_list_uis() ~= 0 then
        vim.api.nvim_command("TSUpdate")
      end
    end,
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSUpdate', 'TSUpdateSync' },
    dependencies = {
      {
        'RRethy/nvim-treesitter-endwise',
        lazy = true,
        ft = { 'lua', 'ruby', 'vimscript' },
      },
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
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
        'help',
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
        'tsx',
        'yaml',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
        disable = function(lang, bufnr)
          if lang == 'html' and vim.api.nvim_buf_line_count(bufnr) > 500 then
            return true
          end
          for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 3, false)) do
            if #line > 500 then
              return true
            end
          end
          return false
        end,
      },
      endwise = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["i,"] = "@parameter.inner",
            ["a,"] = "@parameter.outer",
            ["i="] = "@assignment.rhs",
            ["ir"] = "@return.inner",
            ["ar"] = "@return.outer",
            ["il"] = "@lifetime.inner",
          },
        },
        swap = { enable = true },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["],"] = "@parameter.inner",
            ["]a"] = "@parameter.inner",
            ["]l"] = "@lifetime.inner",
            [']f'] = '@function.outer',
          },
          goto_previous_start = {
            ["[,"] = "@parameter.inner",
            ["[a"] = "@parameter.inner",
            ["[l"] = "@lifetime.inner",
            ['[f'] = '@function.outer',
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      local menu = require 'ht.core.menu'

      local swap = require 'nvim-treesitter.textobjects.swap'

      menu:add_section{
        index = 1,
        opts = {
          {
            'Move Object Left',
            callback = function()
              swap.swap_previous('@parameter.inner')
            end,
          },
          {
            'Move Object Right',
            callback = function()
              swap.swap_next('@parameter.inner')
            end,
          },
        },
      }

    end,
  },
  {
    'nvim-treesitter/playground',
    lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  },
  {
    'Wansmer/treesj',
    lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    init = function()
      local menu = require 'ht.core.menu'

      menu:add_section{
        index = 99,
        opts = {
          {
            "Toggle Split/Join",
            callback = function()
              vim.api.nvim_command("TSJToggle")
            end,
          },
        },
      }
    end,
    config = function()
      local tsj = require('treesj')

      tsj.setup {
        use_default_keymaps = false,
        check_syntax_error = false,
        max_join_length = 120,
      }
    end,
  },
}
