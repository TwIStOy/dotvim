module('walnut.plugins', package.seeall)

local fn = vim.fn
local cmd = vim.api.nvim_command
local ftmap = require('walnut.keymap').ftmap
local _config = require('ht.plugs.utils')._config
local _setup = require('ht.plugs.utils')._setup

local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(packer_install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim ' ..
          packer_install_path)
end

cmd('packadd packer.nvim')

-- Auto recompile plugins when changes in plugin.lua
cmd(
    'autocmd BufWritePost */walnut/plugins.lua echo "Recompile!" | PackerCompile')

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
    setup = function() require('walnut.pcfg.asynctasks').setup() end
  }

  use {'powerman/vim-plugin-AnsiEsc', cmd = {'AnsiEsc'}}

  use 'nvim-lua/plenary.nvim'

  use {'nvim-lua/popup.nvim', requires = {'nvim-lua/plenary.nvim'}}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    cmd = {'Telescope'},
    config = function() require('telescope').setup {} end
  }

  use {
    'fannheyward/telescope-coc.nvim',
    cmd = {'Telescope'},
    requires = {'nvim-telescope/telescope.nvim'},
    config = function() require('telescope').load_extension('coc') end
  }

  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    cmd = {'Telescope'},
    requires = {'nvim-telescope/telescope.nvim'},
    config = function() require('telescope').load_extension('fzy_native') end
  }

  use {
    'fhill2/telescope-ultisnips.nvim',
    cmd = {'Telescope'},
    requires = {'nvim-telescope/telescope.nvim'},
    config = function() require('telescope').load_extension('ultisnips') end
  }

  use {'dstein64/vim-startuptime', cmd = 'StartupTime'}

  use {
    'mhinz/vim-startify',
    cmd = {'Startify'},
    setup = function() require('walnut.pcfg.startify') end
  }

  use 'kyazdani42/nvim-web-devicons'

  use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    config = function() require('walnut.pcfg.nvim_tree') end,
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'liuchengxu/vim-which-key',
    cmd = {'WhichKey'},
    config = function() require('walnut.pcfg.whichkey') end
  }

  use {
    'skywind3000/vim-quickui',
    fn = {'quickui#*'},
    config = function() require('walnut.cfg.menu').setup_menu_items() end
  }

  -- text-objects
  use 'kana/vim-textobj-user'
  use {'lucapette/vim-textobj-underscore', requires = {'kana/vim-textobj-user'}}
  use {'sgur/vim-textobj-parameter', requires = {'kana/vim-textobj-user'}}

  use {
    'TwIStOy/ultisnips',
    ft = {'cpp', 'c', 'markdown', 'vimwiki', 'rust', 'go', 'python'},
    event = 'InsertEnter',
    setup = function() require('walnut.pcfg.ultisnips') end,
    config = function() require('walnut.pcfg.ultisnips').setup_cpp_snippets() end
  }

  use {
    'Yggdroot/LeaderF',
    cmd = {'LeaderF', 'LeaderfFile'},
    run = './install.sh',
    setup = function() require('walnut.pcfg.leaderf') end
  }

  use {
    'TwIStOy/vim-cpp-toolkit',
    cmd = {'LeaderF'},
    fn = {'cpp_toolkit#project_root'},
    setup = function() require('walnut.pcfg.vim_cpp_toolkit') end,
    require = {'Yggdroot/LeaderF'}
  }

  use {
    'akinsho/nvim-toggleterm.lua',
    keys = {'<C-t>'},
    module = {'toggleterm'},
    setup = function()
      vim.api.nvim_set_var('toggleterm_terminal_mapping', '<C-t>')
    end,
    config = function()
      require'toggleterm'.setup {
        open_mapping = '<C-t>',
        hide_numbers = true,
        direction = 'float',
        start_in_insert = true,
        shell = vim.o.shell,
        float_opts = {border = 'double'}
      }
    end
  }

  use {'TwIStOy/conflict-resolve.nvim', fn = 'conflict_resolve#*'}

  use {
    'tpope/vim-surround',
    keys = {'sd', 'cs', 'cS', 'ys', 'yS', 'yss', 'ygs', {'x', 's'}, {'x', 'gS'}},
    setup = function()
      vim.api.nvim_set_var('surround_no_mappings', 0)
      vim.api.nvim_set_var('surround_no_insert_mappings', 1)
    end
  }

  use 'savq/melange'

  use {'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log'}

  use {
    'nacro90/numb.nvim',
    opt = true,
    config = function() require('numb').setup() end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'c', 'cpp', 'toml', 'python', 'rust', 'go', 'typescript', 'lua'
        },
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {} -- list of language that will be disabled
        }
      }
    end
  }

  use {'wakatime/vim-wakatime', opt = true}

  use {'kevinhwang91/nvim-bqf', ft = 'qf', config = _config('bqf')}

  use {
    'tenfyzhong/axring.vim',
    keys = {'<C-a>', '<C-x>'},
    setup = function() require('walnut.pcfg.axring') end
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
    config = function()
      require('bufferline').setup {
        options = {
          view = 'multiwindow',
          separator_style = 'slant',
          numbers = 'both',
          number_style = {"superscript", "subscript"}
        }
      }
      vim.api.nvim_set_keymap('n', '<M-,>', ':BufferLineCyclePrev<CR>',
                              {silent = true, noremap = true})
      vim.api.nvim_set_keymap('n', '<M-.>', ':BufferLineCycleNext<CR>',
                              {silent = true, noremap = true})
      vim.api.nvim_set_keymap('n', '<M-<>', ':BufferLineMovePrev<CR>',
                              {silent = true, noremap = true})
      vim.api.nvim_set_keymap('n', '<M->>', ':BufferLineMoveNext<CR>',
                              {silent = true, noremap = true})
    end
  }

  use {
    'famiu/feline.nvim',
    requires = {'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim'},
    config = function() require('walnut.pcfg.feline.config') end
  }

  use {
    'matze/vim-move',
    keys = {
      '<C-h>', '<C-j>', '<C-k>', '<C-l>', {'v', '<C-h>'}, {'v', '<C-j>'},
      {'v', '<C-k>'}, {'v', '<C-l>'}
    },
    setup = function() vim.api.nvim_set_var('move_key_modifier', 'C') end
  }

  use {'Asheq/close-buffers.vim', cmd = {'Bdelete'}}

  use {
    'aperezdc/vim-template',
    cmd = {'Template', 'TemplateHere'},
    config = function() require('walnut.pcfg.template') end
  }

  use {
    'tomtom/tcomment_vim',
    keys = {'gcc', {'v', 'gcc'}},
    setup = function() vim.api.nvim_set_var('tcomment_maps', 0) end,
    config = function()
      vim.api.nvim_set_keymap('n', 'gcc', ':TComment<CR>',
                              {silent = true, noremap = true})
      vim.api.nvim_set_keymap('v', 'gcc', ':TCommentBlock<CR>',
                              {silent = true, noremap = true})
    end
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
    config = function()
      vim.api.nvim_set_keymap('n', 'J', '<Plug>(jplus)', {silent = true})
      vim.api.nvim_set_keymap('v', 'J', '<Plug>(jplus)', {silent = true})
    end
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
    setup = function()
      vim.api
          .nvim_command [[source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim]]
      vim.g._dotvim_clang_format_exe = vim.g.compiled_llvm_clang_directory ..
                                           '/bin/clang-format'
      vim.g.neoformat_enabled_cpp = {'myclangformat'}
    end,
    config = function()
      require('walnut.keymap').ftmap('*', 'format-file', 'fc',
                                     ':<C-u>Neoformat<CR>')

      vim.g.neoformat_rust_rustfmt2 = {exe = "rustfmt", args = {}, stdin = 1}
      vim.g.neoformat_enabled_rust = {'rustfmt2'}

      vim.g.neoformat_enabled_lua = {'luaformat'}
      -- vim.g.neoformat_lua_luaformat = {exe = 'lua-format'}
    end
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    opt = true,
    setup = function() require('walnut.pcfg.coc').setup() end,
    config = function() require('walnut.pcfg.coc').config() end,
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
    setup = function() require('walnut.pcfg.vimwiki') end,
    config = function() require('walnut.pcfg.vimwiki').config() end,
    requires = {'skywind3000/vim-quickui'}
  }

  use {
    'andymass/vim-matchup',
    setup = [[require('walnut.pcfg.matchup').setup()]],
    config = [[require('walnut.pcfg.matchup').config()]]
  }

  use {
    'dstein64/nvim-scrollview',
    opt = true,
    setup = function()
      vim.g.scrollview_on_startup = 1
      vim.g.scrollview_current_only = 1
      vim.g.scrollview_auto_workarounds = 1
      vim.g.scrollview_nvim_14040_workaround = 1
    end
  }
end)
