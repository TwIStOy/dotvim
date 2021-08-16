local config = require'ht.plugs'.config
local setup = require'ht.plugs'.setup

pkr.startup(function(use)
  use 'wbthomason/packer.nvim'

  use {'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'}}

  use {
    'skywind3000/asynctasks.vim',
    cmd = {'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskProfile', 'AsyncTaskEdit'},
    requires = {'skywind3000/asyncrun.vim'},
    setup = [[require('walnut.pcfg.asynctasks').setup()]]
  }

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
    opt = true,
    after = 'telescope.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('coc')]]
  }

  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    opt = true,
    after = 'telescope.nvim',
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

  use {
    'mhinz/vim-startify',
    cmd = {'Startify'},
    setup = [[require('walnut.pcfg.startify')]]
  }

  use 'kyazdani42/nvim-web-devicons'

  --[[
  use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    config = "require('walnut.pcfg.nvim_tree')",
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  --]]

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
    fn = {'cpp_toolkit#*'},
    setup = [[require('walnut.pcfg.vim_cpp_toolkit')]],
    requires = {'Yggdroot/LeaderF'}
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
    opt = true,
    setup = [[require('ht.plugs.config').surround()]]
  }

  use {
    'monsonjeremy/onedark.nvim',
    config = [[require('walnut.pcfg.onedark').config()]]
  }

  use {'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log'}

  use {'nacro90/numb.nvim', opt = true, config = [[require('numb').setup()]]}

  use {'TwIStOy/nvim-treesitter', run = ':TSUpdate'}

  use {
    'nvim-treesitter/playground',
    cmd = {'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor'}
  }

  use {'kevinhwang91/nvim-bqf', ft = 'qf', config = config('bqf')}

  use {
    'tenfyzhong/axring.vim',
    keys = {'<C-a>', '<C-x>'},
    setup = [[require('walnut.pcfg.axring')]]
  }

  use {'godlygeek/tabular', cmd = {'Tabularize'}}

  use {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign'},
    requires = {'godlygeek/tabular'}
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = config('bufferline')
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = config('gitsigns')
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = config('lualine')
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

  use {
    'kkoomen/vim-doge',
    run = function() vim.fn['doge#install']() end,
    cmd = {'DogeGenerate', 'DogeCreateDocStandard'}
  }

  use {
    'phaazon/hop.nvim',
    cmd = {
      'HopWord', 'HopPattern', 'HopChar1', 'HopChar2', 'HopLine', 'HopLineStart'
    },
    config = function() require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'} end
  }

  use 'rcarriga/nvim-notify'

  use { 'haringsrob/nvim_context_vt',
    config = config('nvim_context_vt'),
  }

  use_rocks "lualogging"
end)

function PluginsUsage(use)
  use 'wbthomason/packer.nvim'

  use {'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'}}

  use {
    'skywind3000/asynctasks.vim',
    cmd = {'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskProfile', 'AsyncTaskEdit'},
    requires = {'skywind3000/asyncrun.vim'},
    setup = [[require('walnut.pcfg.asynctasks').setup()]]
  }

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
    opt = true,
    after = 'telescope.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = [[require('telescope').load_extension('coc')]]
  }

  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    opt = true,
    after = 'telescope.nvim',
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

  use {
    'mhinz/vim-startify',
    cmd = {'Startify'},
    setup = [[require('walnut.pcfg.startify')]]
  }

  use 'kyazdani42/nvim-web-devicons'

  --[[
  use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    config = "require('walnut.pcfg.nvim_tree')",
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  --]]

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
    fn = {'cpp_toolkit#*'},
    setup = [[require('walnut.pcfg.vim_cpp_toolkit')]],
    requires = {'Yggdroot/LeaderF'}
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
    opt = true,
    setup = [[require('ht.plugs.config').surround()]]
  }

  use {
    'monsonjeremy/onedark.nvim',
    config = [[require('walnut.pcfg.onedark').config()]]
  }

  use {'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log'}

  use {'nacro90/numb.nvim', opt = true, config = [[require('numb').setup()]]}

  use {'TwIStOy/nvim-treesitter', run = ':TSUpdate'}

  use {
    'nvim-treesitter/playground',
    cmd = {'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor'}
  }

  use {'kevinhwang91/nvim-bqf', ft = 'qf', config = config('bqf')}

  use {
    'tenfyzhong/axring.vim',
    keys = {'<C-a>', '<C-x>'},
    setup = [[require('walnut.pcfg.axring')]]
  }

  use {'godlygeek/tabular', cmd = {'Tabularize'}}

  use {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign'},
    requires = {'godlygeek/tabular'}
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = config('bufferline')
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = config('gitsigns')
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = config('lualine')
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
    config = function()
      require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'}
    end
  }

  use 'rcarriga/nvim-notify'

  use {'haringsrob/nvim_context_vt', config = config('nvim_context_vt')}

  use_rocks "lualogging"
end
