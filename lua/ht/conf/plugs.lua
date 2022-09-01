module('ht.conf.plugs', package.seeall)

local Config = require'ht.plugs'.Config
local Setup = require'ht.plugs'.Setup

function UsePlugins(use)
  local loader = require'ht.plugins.init'.loader:new(use)

  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use 'kyazdani42/nvim-web-devicons'

  use 'nvim-lua/plenary.nvim'

  loader:setup 'asynctasks'

  use { 'nvim-lua/popup.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  loader:setup 'nvim_tree'

  loader:setup 'diffview'

  loader:setup 'telescope'

  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  use 'stevearc/dressing.nvim'

  loader:setup 'lastplace'

  loader:setup 'alpha'

  --[[
  use {
    'liuchengxu/vim-which-key',
    cmd = { 'WhichKey' },
    config = Config('whichkey'),
  }
  --]]

  loader:setup 'quickui'

  -- text-objects
  use { 'kana/vim-textobj-user', opt = true }
  use {
    'lucapette/vim-textobj-underscore',
    opt = true,
    after = 'vim-textobj-user',
    requires = { 'kana/vim-textobj-user' },
  }
  use {
    'sgur/vim-textobj-parameter',
    opt = true,
    after = 'vim-textobj-user',
    requires = { 'kana/vim-textobj-user' },
  }

  loader:setup 'ultisnips'

  loader:setup 'leaderf'

  use {
    'TwIStOy/vim-cpp-toolkit',
    fn = { 'cpp_toolkit#*' },
    opt = true,
    config = Config('vim_cpp_toolkit'),
    requires = { 'Yggdroot/LeaderF' },
    wants = 'LeaderF',
  }

  use {
    'akinsho/toggleterm.nvim',
    tag = 'v2.*',
    keys = { '<C-t>' },
    module = { 'toggleterm' },
    setup = Setup('toggleterm'),
    config = Config('toggleterm'),
  }

  use { 'TwIStOy/conflict-resolve.nvim', fn = 'conflict_resolve#*' }

  use {
    'tpope/vim-surround',
    opt = true,
    setup = [[require('ht.plugs.config').surround()]],
  }

  use {
    'projekt0n/github-nvim-theme',
    config = function()
      require("github-theme").setup {
        theme_style = 'dimmed',
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
      }
    end,
  }

  use {
    'jedrzejboczar/possession.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    after = 'telescope.nvim',
    wants = 'telescope.nvim',
    config = function()
      require'possession'.setup {
        commands = {
          save = 'SSave',
          load = 'SLoad',
          delete = 'SDelete',
          list = 'SList',
        },
      }
      require('telescope').load_extension('possession')
    end,
  }

  use { 'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log' }

  use { 'nacro90/numb.nvim', opt = true, config = [[require('numb').setup()]] }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'nvim-treesitter/playground',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  }

  loader:setup 'nvim_bqf'

  loader:setup 'dial'

  use { 'godlygeek/tabular', cmd = { 'Tabularize' } }

  use {
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign' },
    requires = { 'godlygeek/tabular' },
  }

  loader:setup 'bufferline'

  loader:setup 'gitsigns'

  loader:setup 'lualine'

  use {
    'matze/vim-move',
    keys = {
      '<C-h>',
      '<C-j>',
      '<C-k>',
      '<C-l>',
      { 'v', '<C-h>' },
      { 'v', '<C-j>' },
      { 'v', '<C-k>' },
      { 'v', '<C-l>' },
    },
    setup = [[
      vim.g.move_key_modifier = 'C'
      vim.g.move_key_modifier_visualmode = 'C'
    ]],
  }

  use { 'Asheq/close-buffers.vim', cmd = { 'Bdelete' } }

  use {
    'aperezdc/vim-template',
    cmd = { 'Template', 'TemplateHere' },
    setup = Setup('template'),
  }

  use {
    'tomtom/tcomment_vim',
    keys = { 'gcc', { 'v', 'gcc' } },
    setup = [[vim.g.tcomment_maps = 0]],
    config = [[require('ht.plugs.config').tcomment()]],
  }

  use {
    'RRethy/vim-illuminate',
    opt = true,
    setup = function()
      vim.api.nvim_set_var('Illuminate_delay', 200)
      vim.api.nvim_set_var('Illuminate_ftblacklist', { 'nerdtree', 'defx' })
    end,
  }

  use {
    'osyo-manga/vim-jplus',
    keys = { 'J', { 'v', 'J' } },
    config = [[require('ht.plugs.config').vim_jplus()]],
  }

  use 'tpope/vim-repeat'

  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.api.nvim_command [[au FileType which_key DisableWhitespace]]
    end,
  }

  use { 'AndrewRadev/sideways.vim', cmd = { 'SidewaysLeft', 'SidewaysRight' } }

  loader:setup 'neoformat'

  use { 't9md/vim-quickhl', cmd = { 'QuickhlManualReset' },
        fn = { 'quickhl#*' } }

  use { 'plasticboy/vim-markdown', ft = { 'markdown', 'pandoc.markdown' } }

  use {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown', 'pandoc.markdown', 'rmd' },
    run = 'sh -c "cd app && yarn install"',
  }

  use {
    'andymass/vim-matchup',
    keys = { { 'n', '%' }, { 'x', '%' }, { 'o', '%' } },
    setup = Setup('matchup'),
    config = Config('matchup'),
  }

  loader:setup 'scrollview'

  loader:setup 'hop'

  use 'rcarriga/nvim-notify'

  use {
    'anufrievroman/vim-angry-reviewer',
    setup = function()
      vim.g.AngryReviewerEnglish = 'american'
    end,
    cmd = { 'AngryReviewer' },
  }

  loader:setup 'nvim_cmp'

  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text' },
  }

  use { 'neovim/nvim-lspconfig' }

  use {
    'j-hui/fidget.nvim',
    requires = 'neovim/nvim-lspconfig',
    config = function()
      require"fidget".setup {}
    end,
  }

  use { 'simrat39/symbols-outline.nvim', requires = 'neovim/nvim-lspconfig' }

  use { 'p00f/clangd_extensions.nvim', requires = 'neovim/nvim-lspconfig' }

  use { 'simrat39/rust-tools.nvim', requires = 'neovim/nvim-lspconfig' }

  use { 'onsails/lspkind-nvim', requires = 'neovim/nvim-lspconfig' }

  use {
    'seblj/nvim-echo-diagnostics',
    requires = 'neovim/nvim-lspconfig',
    config = function()
      require("echo-diagnostics").setup {
        show_diagnostic_number = true,
        show_diagnostic_source = false,
      }

      require'ht.core.vim'.event:on('CursorHold', '*', function()
        require('echo-diagnostics').echo_line_diagnostic()
      end)
    end,
  }

  use {
    'folke/trouble.nvim',
    requires = { 'folke/lsp-colors.nvim' },
    config = function()
      require'trouble'.setup {}
    end,
  }

  loader:setup 'neogen'

  use_rocks 'lualogging'

  use_rocks 'luachild'
end

