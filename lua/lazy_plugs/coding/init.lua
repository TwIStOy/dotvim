return {
  {
    'TwIStOy/ultisnips',
    event = "InsertEnter",
    config = function()
      vim.cmd [[py3 from snippet_tools.cpp import register_postfix_snippets]]
      vim.cmd [[py3 register_postfix_snippets()]]
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'TwIStOy/ultisnips',
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-under-comparator',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'dmitmel/cmp-digraphs',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'zbirenbaum/copilot-cmp',
      'zbirenbaum/copilot.lua',
    },
    config = require'lazy_plugs.coding.nvim-cmp'.config,
  },

  -- text-object groups
  { 'kana/vim-textobj-user', event = 'VeryLazy' },
  {
    'lucapette/vim-textobj-underscore',
    event = 'VeryLazy',
    dependencies = { 'kana/vim-textobj-user' },
  },
  {
    'sgur/vim-textobj-parameter',
    event = 'VeryLazy',
    dependencies = { 'kana/vim-textobj-user' },
  },

  -- highlight todo comments
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = {
      highlight = { keyword = 'bg', pattern = [[.*<(KEYWORDS)\([^)]*\):]] },
    },
  },

  -- asynctask
  {
    'skywind3000/asynctasks.vim',
    cmd = { 'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskProfile', 'AsyncTaskEdit' },
    init = function()
      -- quickfix window height
      vim.g.asyncrun_open = 10
      -- disable bell after finished
      vim.g.asyncrun_bell = 0

      vim.g.asyncrun_rootmarks = {
        'BLADE_ROOT', -- for blade(c++)
        'JK_ROOT', -- for jk(c++)
        'WORKSPACE', -- for bazel(c++)
        '.buckconfig', -- for buck(c++)
        'CMakeLists.txt', -- for cmake(c++)
      }

      vim.g.asynctasks_extra_config =
          { '~/.dotfiles/dots/tasks/asynctasks.ini' }
    end,
    keys = {
      { '<leader>bf', '<cmd>AsyncTask file-build<CR>', desc = 'build-file' },
      { '<leader>bp', '<cmd>AsyncTask project-build<CR>',
        desc = 'build-project' },
    },
  },
  { { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun', 'AsyncStop' } } },

  -- for cp programming
  {
    'p00f/cphelper.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = { 'CphReceive', 'CphTest', 'CphRetest', 'CphEdit', 'CphDelete' },
    keys = { { '<F9>', '<cmd>CphTest<CR>', desc = 'Run cp test' } },
    init = function()
      vim.g['cph#dir'] = '/Users/hawtian/Projects/competitive-programming'
      vim.g['cph#lang'] = 'cpp'
      vim.g['cph#rust#createjson'] = true
      vim.g['cph#cpp#compile_command'] =
          'g++ solution.cpp -std=c++20 -o cpp.out'
    end,
  },

  -- formatters
  {
    'sbdchd/neoformat',
    event = 'BufReadPost',
    keys = { { '<leader>fc', '<cmd>Neoformat<CR>', desc = 'format-file' } },
    init = function() -- code to run before plugin loaded
      vim.g.neoformat_only_msg_on_error = 1
      vim.g.neoformat_basic_format_align = 1
      vim.g.neoformat_basic_format_retab = 1
      vim.g.neoformat_basic_format_trim = 1
    end,
    config = function() -- code to run after plugin loaded
      local Menu = require 'nui.menu'
      local menu = require 'ht.core.menu'

      vim.cmd [[source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim]]
      vim.g._dotvim_clang_format_exe = vim.g.compiled_llvm_clang_directory ..
                                           '/bin/clang-format'
      vim.g.neoformat_enabled_cpp = { 'myclangformat' }

      menu:append_section('*', {
        Menu.item('Format File', {
          action = function()
            vim.cmd 'Neoformat'
          end,
        }),
      })

      vim.g.neoformat_rust_rustfmt2 = { exe = "rustfmt", args = {}, stdin = 1 }
      vim.g.neoformat_enabled_rust = { 'rustfmt2' }
      vim.g.neoformat_enabled_lua = { 'luaformat' }
    end,
  },

  -- move arguments
  {
    'AndrewRadev/sideways.vim',
    cmd = { 'SidewaysLeft', 'SidewaysRight' },
    init = function()
      local Menu = require 'nui.menu'
      local menu = require 'ht.core.menu'

      menu:append_section('*', {
        Menu.item('Move Object Left', {
          action = function()
            vim.cmd 'SidewaysLeft'
          end,
        }),
        Menu.item('Move Object Right', {
          action = function()
            vim.cmd 'SidewaysRight'
          end,
        }),
      })
    end,
  },

  -- templates
  {
    'aperezdc/vim-template',
    cmd = { 'Template', 'TemplateHere' },
    init = function()
      vim.g.templates_directory = {
        os.getenv('HOME') .. [[/.dotvim/vim-templates]],
      }
      vim.g.templates_no_autocmd = 0
      vim.g.templates_debug = 0
      vim.g.templates_no_builtin_templates = 1
    end,
  },

  -- toggle code comments
  {
    'tomtom/tcomment_vim',
    event = 'BufReadPost',
    init = function()
      vim.g.tcomment_maps = 0
    end,
    keys = {
      { 'gcc', '<cmd>TComment<CR>', desc = 'toggle-comment' },
      { 'gcc', ':TCommentBlock<CR>', mode = 'v', desc = 'toggle-comment' },
    },
  },
}
