module('ht.conf.plugs', package.seeall)

local Config = require'ht.plugs'.Config
local Setup = require'ht.plugs'.Setup

function UsePlugins(use)
  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use 'kyazdani42/nvim-web-devicons'

  use {'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'}}

  use {
    'skywind3000/asynctasks.vim',
    cmd = {'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskProfile', 'AsyncTaskEdit'},
    requires = {'skywind3000/asyncrun.vim'},
    setup = Setup('asynctasks'),
    wants = {'asyncrun.vim'}
  }

  use 'nvim-lua/plenary.nvim'

  use {'nvim-lua/popup.nvim', requires = {'nvim-lua/plenary.nvim'}}

  use {
    'kyazdani42/nvim-tree.lua',
    config = Config('nvim_tree'),
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'sindrets/diffview.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = Config('diffview')
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    cmd = {'Telescope'},
    config = Config('telescope')
  }

  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    opt = true,
    after = 'telescope.nvim',
    wants = 'telescope.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('fzy_native')]]
  }

  use {
    'fhill2/telescope-ultisnips.nvim',
    opt = true,
    after = 'telescope.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('ultisnips')]]
  }

  use {'dstein64/vim-startuptime', cmd = 'StartupTime'}

  use {'mhinz/vim-startify', cmd = {'Startify'}, setup = Config('startify')}

  use {
    'liuchengxu/vim-which-key',
    cmd = {'WhichKey'},
    config = Config('whichkey')
  }

  use {
    'skywind3000/vim-quickui',
    fn = {'quickui#*'},
    setup = Setup('quickui'),
    config = Config('quickui')
  }

  -- text-objects
  use {'kana/vim-textobj-user', opt = true}
  use {
    'lucapette/vim-textobj-underscore',
    opt = true,
    after = 'vim-textobj-user',
    requires = {'kana/vim-textobj-user'}
  }
  use {
    'sgur/vim-textobj-parameter',
    opt = true,
    after = 'vim-textobj-user',
    requires = {'kana/vim-textobj-user'}
  }

  use {
    'TwIStOy/ultisnips',
    ft = {'cpp', 'c', 'markdown', 'vimwiki', 'rust', 'go', 'python'},
    event = 'InsertEnter',
    setup = Setup('ultisnips'),
    config = Config('ultisnips')
  }

  use {
    'Yggdroot/LeaderF',
    cmd = {'LeaderF', 'LeaderfFile'},
    run = './install.sh',
    setup = Setup('leaderf')
  }

  use {
    'TwIStOy/vim-cpp-toolkit',
    fn = {'cpp_toolkit#*'},
    opt = true,
    config = Config('vim_cpp_toolkit'),
    requires = {'Yggdroot/LeaderF'},
    wants = 'LeaderF'
  }

  use {
    'akinsho/nvim-toggleterm.lua',
    keys = {'<C-t>'},
    module = {'toggleterm'},
    setup = Setup('toggleterm'),
    config = Config('toggleterm')
  }

  use {'TwIStOy/conflict-resolve.nvim', fn = 'conflict_resolve#*'}

  use {
    'tpope/vim-surround',
    opt = true,
    setup = [[require('ht.plugs.config').surround()]]
  }

  use {
    'folke/tokyonight.nvim',
    setup = function()
      vim.g.tokyonight_style = 'storm'
      vim.g.tokyonight_italic_variables = true
      vim.g.tokyonight_hide_inactive_statusline = false
      vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
      vim.g.tokyonight_lualine_bold = true
    end,
    config = function()
      vim.cmd('colorscheme tokyonight')
    end
  }

  use {'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log'}

  use {'nacro90/numb.nvim', opt = true, config = [[require('numb').setup()]]}

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  use {
    'nvim-treesitter/playground',
    cmd = {'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor'}
  }

  use {'kevinhwang91/nvim-bqf', ft = 'qf', config = Config('bqf')}

  use {'monaqa/dial.nvim', keys = {'<C-a>', '<C-x>'}, config = Config('dial')}

  use {'godlygeek/tabular', cmd = {'Tabularize'}}

  use {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign'},
    requires = {'godlygeek/tabular'}
  }

  use {'akinsho/bufferline.nvim', requires = {'kyazdani42/nvim-web-devicons'}}

  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = Config('gitsigns')
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = Config('lualine')
  }

  use {
    'matze/vim-move',
    keys = {
      '<C-h>', '<C-j>', '<C-k>', '<C-l>', {'v', '<C-h>'}, {'v', '<C-j>'},
      {'v', '<C-k>'}, {'v', '<C-l>'}
    },
    setup = [[vim.g.move_key_modifier = 'C']]
  }

  use {'Asheq/close-buffers.vim', cmd = {'Bdelete'}}

  use {
    'aperezdc/vim-template',
    cmd = {'Template', 'TemplateHere'},
    setup = Setup('template')
  }

  use {
    'tomtom/tcomment_vim',
    keys = {'gcc', {'v', 'gcc'}},
    setup = [[vim.g.tcomment_maps = 0]],
    config = [[require('ht.plugs.config').tcomment()]]
  }

  use {
    'RRethy/vim-illuminate',
    opt = true,
    setup = function()
      vim.api.nvim_set_var('Illuminate_delay', 200)
      vim.api.nvim_set_var('Illuminate_ftblacklist', {'nerdtree', 'defx'})
    end
  }

  use {
    'osyo-manga/vim-jplus',
    keys = {'J', {'v', 'J'}},
    config = [[require('ht.plugs.config').vim_jplus()]]
  }

  use 'tpope/vim-repeat'

  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.api.nvim_command [[au FileType which_key DisableWhitespace]]
    end
  }

  use {'AndrewRadev/sideways.vim', cmd = {'SidewaysLeft', 'SidewaysRight'}}

  use {
    'sbdchd/neoformat',
    event = 'BufRead',
    setup = Setup('neoformat'),
    config = Config('neoformat')
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    opt = true,
    setup = Setup('coc'),
    config = Config('coc'),
    requires = {'skywind3000/vim-quickui'}
  }

  use {'t9md/vim-quickhl', cmd = {'QuickhlManualReset'}, fn = {'quickhl#*'}}

  use {'plasticboy/vim-markdown', ft = {'markdown', 'pandoc.markdown'}}

  use {
    'iamcco/markdown-preview.nvim',
    ft = {'markdown', 'pandoc.markdown', 'rmd'},
    run = 'sh -c "cd app && yarn install"'
  }

  use {
    'vimwiki/vimwiki',
    cmd = {
      'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect', 'VimwikiDiaryIndex',
      'VimwikiMakeDiaryNote', 'VimwikiTabMakeDiaryNote',
      'VimwikiMakeYesterdayDiaryNote', 'VimwikiMakeTomorrowDiaryNote'
    },
    setup = Setup('vimwiki'),
    config = Config('vimwiki'),
    requires = {'skywind3000/vim-quickui'}
  }

  use {
    'andymass/vim-matchup',
    keys = {{'n', '%'}, {'x', '%'}, {'o', '%'}},
    setup = Setup('matchup'),
    config = Config('matchup')
  }

  use {'dstein64/nvim-scrollview', opt = true, setup = Setup('scrollview')}

  use {
    'kkoomen/vim-doge',
    run = function()
      vim.fn['doge#install']()
    end,
    cmd = {'DogeGenerate', 'DogeCreateDocStandard'}
  }

  use {
    'phaazon/hop.nvim',
    cmd = {
      'HopWord', 'HopPattern', 'HopChar1', 'HopChar2', 'HopLine', 'HopLineStart'
    },
    config = Config('hop')
  }

  use 'rcarriga/nvim-notify'

  use {
    'anufrievroman/vim-angry-reviewer',
    setup = function()
      vim.g.AngryReviewerEnglish = 'american'
    end,
    cmd = {
      'AngryReviewer'
    }
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("indent_blankline").setup {
        char = "|",
        buftype_exclude = {"terminal"},
        use_treesitter = true,
        filetype_exclude = {'startify', 'help', 'packer'},
      }
    end
  }

  use_rocks 'lualogging'

  use_rocks 'luachild'
end

