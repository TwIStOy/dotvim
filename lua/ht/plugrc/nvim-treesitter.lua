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
    dependencies = { 'RRethy/nvim-treesitter-endwise' },
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
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
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
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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
      local Menu = require 'nui.menu'
      menu:append_section("*", {
        Menu.item("Toggle Split/Join", {
          action = function()
            vim.api.nvim_command("TSJToggle")
          end,
        }),
      }, 99)
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
