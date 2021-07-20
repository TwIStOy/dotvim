module('walnut.plugins', package.seeall)

local fn = vim.fn
local cmd = vim.api.nvim_command
local ftmap = require('walnut.keymap').ftmap
local config = require('ht.plugs.utils').config
local setup = require('ht.plugs.utils').setup

local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(packer_install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim ' ..
          packer_install_path)
end

cmd('packadd packer.nvim')

-- Auto recompile plugins when changes in plugin.lua
vim.cmd [[
augroup packer_recompile
  autocmd!
  autocmd BufWritePost */walnut/plugins.lua echo "Recompile!" | source <afile> | PackerCompile
augroup END
]]

local pkr = require('packer')
pkr.init({
  ensure_dependencies = true,
  display = {
    auto_clean = false,
    open_fn = function()
      return require('packer.util').float {border = 'single'}
    end
  }
})

pkr.startup(function(use)
  use 'wbthomason/packer.nvim'

  use {'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'}}

  use {
    'skywind3000/asynctasks.vim',
    cmd = {'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskProfile', 'AsyncTaskEdit'},
    requires = {'skywind3000/asyncrun.vim'},
    setup = [[require('walnut.pcfg.asynctasks').setup()]]
  }

  use {'powerman/vim-plugin-AnsiEsc', cmd = {'AnsiEsc'}}

  use 'nvim-lua/plenary.nvim'

  use {'nvim-lua/popup.nvim', requires = {'nvim-lua/plenary.nvim'}}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    cmd = {'Telescope'},
    config = [[require('telescope').setup {}]]
  }

  use {
    'fannheyward/telescope-coc.nvim',
    cmd = {'Telescope'},
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('coc')]]
  }

  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    cmd = {'Telescope'},
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('fzy_native')]]
  }

  use {
    'fhill2/telescope-ultisnips.nvim',
    cmd = {'Telescope'},
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('ultisnips')]]
  }

  use {'dstein64/vim-startuptime', cmd = 'StartupTime'}

  use {
    'mhinz/vim-startify',
    cmd = {'Startify'},
    setup = [[require('walnut.pcfg.startify')]]
  }

  use 'kyazdani42/nvim-web-devicons'

  use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    config = [[require('walnut.pcfg.nvim_tree')]],
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'liuchengxu/vim-which-key',
    cmd = {'WhichKey'},
    config = [[require('walnut.pcfg.whichkey')]]
  }

  use {
    'skywind3000/vim-quickui',
    fn = {'quickui#*'},
    config = [[require('walnut.cfg.menu').setup_menu_items()]]
  }

  -- text-objects
  use 'kana/vim-textobj-user'
  use {'lucapette/vim-textobj-underscore', requires = {'kana/vim-textobj-user'}}
  use {'sgur/vim-textobj-parameter', requires = {'kana/vim-textobj-user'}}

  use {
    'TwIStOy/ultisnips',
    ft = {'cpp', 'c', 'markdown', 'vimwiki', 'rust', 'go', 'python'},
    event = 'InsertEnter',
    setup = [[require('walnut.pcfg.ultisnips')]],
    config = [[require('walnut.pcfg.ultisnips').setup_cpp_snippets()]]
  }

  use {
    'Yggdroot/LeaderF',
    cmd = {'LeaderF', 'LeaderfFile'},
    run = './install.sh',
    setup = [[require('walnut.pcfg.leaderf')]]
  }

  use {
    'TwIStOy/vim-cpp-toolkit',
    cmd = {'LeaderF'},
    fn = {'cpp_toolkit#project_root'},
    setup = [[require('walnut.pcfg.vim_cpp_toolkit')]],
    require = {'Yggdroot/LeaderF'}
  }

  use {
    'akinsho/nvim-toggleterm.lua',
    keys = {'<C-t>'},
    module = {'toggleterm'},
    setup = setup('toggleterm'),
    config = config('toggleterm')
  }

  use {'TwIStOy/conflict-resolve.nvim', fn = 'conflict_resolve#*'}

  use {
    'tpope/vim-surround',
    keys = {
      'sd', 'cs', 'cS', 'ys', 'yS', 'yss', 'ygs', {'x', 's'}, {'x', 'gS'}, 'ds'
    },
    setup = [[require('ht.plugs.config').surround()]]
  }

  use 'savq/melange'

  use {'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log'}

  use {'nacro90/numb.nvim', opt = true, config = [[require('numb').setup()]]}

  use {
    'nvim-treesitter/nvim-treesitter',
    config = [[require('ht.plugs.config').treesitter()]]
  }

  use {'wakatime/vim-wakatime', opt = true}

  use {'kevinhwang91/nvim-bqf', ft = 'qf', config = config('bqf')}

  use {
    'tenfyzhong/axring.vim',
    keys = {'<C-a>', '<C-x>'},
    setup = [[require('walnut.pcfg.axring')]]
  }

  use {'godlygeek/tabular', cmd = {'Tabularize'}}

  use {
    'junegunn/vim-easy-align',
    cmd = {'EsayAlign'},
    requires = {'godlygeek/tabular'}
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = config('bufferline')
  }

  use {
    'famiu/feline.nvim',
    requires = {'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim'},
    config = [[require('walnut.pcfg.feline.config')]]
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
    config = [[require('walnut.pcfg.template')]]
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
    config = [[require('ht.plugs.config').vim_jplus()]],
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
    setup = [[require('walnut.pcfg.neoformat').setup()]],
    config = [[require('walnut.pcfg.neoformat').config()]]
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    opt = true,
    setup = [[require('walnut.pcfg.coc').setup()]],
    config = [[require('walnut.pcfg.coc').config()]],
    requires = {'skywind3000/vim-quickui'}
  }

  use {'t9md/vim-quickhl', keys = {'n', 'N', '*', '#', '/', '?', 'g*', 'g#'}}

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
    setup = setup('vimwiki'),
    config = config('vimwiki'),
    requires = {'skywind3000/vim-quickui'}
  }

  use {
    'andymass/vim-matchup',
    keys = {{'n', '%'}, {'x', '%'}, {'o', '%'}},
    setup = setup('matchup'),
    config = config('matchup')
  }

  use {'dstein64/nvim-scrollview', opt = true, setup = setup('scrollview')}
end)
