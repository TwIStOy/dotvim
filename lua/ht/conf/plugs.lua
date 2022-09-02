module('ht.conf.plugs', package.seeall)

function UsePlugins(use)
  local loader = require'ht.plugins.init'.loader:new(use)

  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use 'kyazdani42/nvim-web-devicons'

  use 'nvim-lua/plenary.nvim'

  use { 'nvim-lua/popup.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  use 'stevearc/dressing.nvim'

  loader:setup 'asynctasks'

  loader:setup 'nvim_tree'

  loader:setup 'diffview'

  loader:setup 'telescope'

  loader:setup 'lastplace'

  loader:setup 'alpha'

  loader:setup 'whichkey'

  loader:setup 'quickui'

  loader:setup 'textobject'

  loader:setup 'ultisnips'

  loader:setup 'leaderf'

  loader:setup 'vim_cpp_toolkit'

  loader:setup 'toggleterm'

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

  loader:setup 'template'

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

  use { 'plasticboy/vim-markdown', ft = { 'markdown', 'pandoc.markdown' } }

  use {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown', 'pandoc.markdown', 'rmd' },
    run = 'sh -c "cd app && yarn install"',
  }

  loader:setup 'matchup'

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

  loader:setup 'lsp'

  loader:setup 'trouble'

  loader:setup 'neogen'

  use_rocks 'lualogging'

  use_rocks 'luachild'

  _G['dotvim_plugins_loader'] = loader
end

