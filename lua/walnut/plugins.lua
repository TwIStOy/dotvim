module('walnut.plugins', package.seeall)

local fn = vim.fn
local cmd = vim.api.nvim_command
local ftmap = require('walnut.keymap').ftmap

local packer_install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(packer_install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_install_path)
end

cmd('packadd packer.nvim')

-- Auto recompile plugins when changes in plugin.lua
cmd('autocmd BufWritePost */walnut/plugins.lua echo "Recompile!" | PackerCompile')

local pkr = require('packer')
pkr.init({
  ensure_dependencies = true,
  display = {
    auto_clean = false
  }
})

pkr.startup(function(use)
  use { 'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'} }

  -- git tools
  use {
    'airblade/vim-gitgutter',
    setup = function()
      vim.api.nvim_set_var('gitgutter_map_keys', 0)
      vim.api.nvim_set_var('gitgutter_signs', 0)
    end
  }

  use {
    'arcticicestudio/nord-vim',
    config = function()
      vim.api.nvim_command [[colorscheme nord]]
    end
  }

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime'
  }

  use {
    'mhinz/vim-startify',
    cmd = {'Startify'},
    setup = function() require('walnut.pcfg.startify') end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require('walnut.pcfg.nvim_tree') end,
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use {
    'liuchengxu/vim-which-key',
    cmd = { 'WhichKey' },
    config = function() require('walnut.pcfg.whichkey') end
  }

  use {
    'skywind3000/vim-quickui',
    config = function()
      require('walnut.cfg.menu').setup_menu_items()
    end
  }

  -- text-objects
  use 'kana/vim-textobj-user'
  use { 'kana/vim-textobj-indent', requires = { 'kana/vim-textobj-user' }}
  use { 'kana/vim-textobj-line', requires = { 'kana/vim-textobj-user' }}
  use { 'kana/vim-textobj-entire', requires = { 'kana/vim-textobj-user' }}
  use { 'lucapette/vim-textobj-underscore', requires = { 'kana/vim-textobj-user' }}
  use { 'sgur/vim-textobj-parameter', requires = { 'kana/vim-textobj-user' }}

  use {
    'TwIStOy/ultisnips',
    setup = function() require('walnut.pcfg.ultisnips') end,
    config = function() require('walnut.pcfg.ultisnips').setup_cpp_snippets() end
  }

  use {
    'Yggdroot/LeaderF',
    run = './install.sh',
    setup = function() require('walnut.pcfg.leaderf') end
  }

  use {
    'TwIStOy/vim-cpp-toolkit',
    setup = function()
      require('walnut.pcfg.vim_cpp_toolkit')
    end,
    require = {
      'Yggdroot/LeaderF',
    }
  }

  use {
    'akinsho/nvim-toggleterm.lua',
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
        float_opts = {
          border = 'shadow'
        }
      }
    end
  }

  use 'tpope/vim-surround'

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.api.nvim_set_var('surround_no_mappings', 0)
      vim.api.nvim_set_var('surround_no_insert_mappings', 1)
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'c', 'cpp', 'toml',
          'python', 'rust', 'go',
          'typescript', 'lua',
        },
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {},  -- list of language that will be disabled
        },
      }
    end
  }

  use 'wakatime/vim-wakatime'

  use {
    'tenfyzhong/axring.vim',
    config = function() require('walnut.pcfg.axring') end
  }

  use {
    'godlygeek/tabular',
    cmd = { 'Tabularize' }
  }

  use {
    'junegunn/vim-easy-align',
    cmd = { 'EsayAlign' },
    requires = {
      'godlygeek/tabular',
    },
    config = function()
      ftmap('*', 'easy-align', 'ta', ':EasyAlign<CR>')
      vim.api.nvim_set_keymap('x', '<leader>ta', ':EasyAlign<CR>', { silent = true })
    end
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require('bufferline').setup{
        options = {
          view = 'multiwindow',
          separator_style = 'slant',
          numbers = 'both',
          number_style = {"superscript", "subscript"},
        }
      }
      vim.api.nvim_set_keymap('n', '<M-,>', ':BufferLineCyclePrev<CR>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', '<M-.>', ':BufferLineCycleNext<CR>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', '<M-<>', ':BufferLineMovePrev<CR>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', '<M->>', ':BufferLineMoveNext<CR>', { silent = true, noremap = true })
    end
  }

  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    requires = {
      'kyazdani42/nvim-web-devicons',
      'airblade/vim-gitgutter',
    },
    config = function() require('walnut.pcfg.galaxyline') end
  }

  use {
    'matze/vim-move',
    setup = function()
      vim.api.nvim_set_var('move_key_modifier', 'C')
    end
  }

  use 'farmergreg/vim-lastplace'

  use {
    'Asheq/close-buffers.vim',
    cmd = {
      'Bdelete'
    }
  }

  use {
    'aperezdc/vim-template',
    config = function() require('walnut.pcfg.template') end
  }

  use {
    'tomtom/tcomment_vim',
    setup = function()
      vim.api.nvim_set_var('tcomment_maps', 0)
      vim.api.nvim_set_keymap('n', 'gcc', ':TComment<CR>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('v', 'gcc', ':TCommentBlock<CR>', { silent = true, noremap = true })
    end
  }

  use {
    'RRethy/vim-illuminate',
    setup = function()
      vim.api.nvim_set_var('Illuminate_delay', 200)
      vim.api.nvim_set_var('Illuminate_ftblacklist', { 'nerdtree', 'defx' })
    end
  }

  use 'andymass/vim-matchup'

  use {
    'osyo-manga/vim-jplus',
    config = function()
      vim.api.nvim_set_keymap('n', 'J', '<Plug>(jplus)', { silent = true })
      vim.api.nvim_set_keymap('v', 'J', '<Plug>(jplus)', { silent = true })
    end
  }

  use 'tpope/vim-repeat'

  use {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.api.nvim_command [[au FileType which_key DisableWhitespace]]
    end
  }

  use {
    'AndrewRadev/sideways.vim',
    cmd = { 'SidewaysLeft', 'SidewaysRight' },
    config = function()
      vim.api.nvim_set_keymap('n', '<M-h>', ':SidewaysLeft<CR>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', '<M-l>', ':SidewaysRight<CR>', { silent = true, noremap = true })
    end
  }

  use {
    'sbdchd/neoformat',
    setup = function()
      vim.api.nvim_command[[source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim]]
      vim.g._dotvim_clang_format_exe = vim.g.compiled_llvm_clang_directory .. '/bin/clang-format'
      vim.g.neoformat_enabled_cpp = { 'myclangformat' }
    end,
    config = function()
      require('walnut.keymap').ftmap('*', 'format-file', 'fc', ':<C-u>Neoformat<CR>')
    end
  }

  use {
    'justinmk/vim-sneak',
    setup = function()
      vim.api.nvim_set_var('sneak#label', 1)
    end
  }

  use {
    'neoclide/coc.nvim',
    branch = 'release',
    setup = function()
      require('walnut.pcfg.coc').setup()
    end,
    config = function()
      require('walnut.pcfg.coc').config()
    end,
    requires = {
      'skywind3000/vim-quickui',
    }
  }

  use 't9md/vim-quickhl'

  use {
    'plasticboy/vim-markdown',
    ft = { 'markdown', 'pandoc.markdown' }
  }

  use {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown', 'pandoc.markdown', 'rmd', },
    run = 'sh -c "cd app && yarn install"'
  }

  use {
    'vimwiki/vimwiki',
    setup = function()
      require('walnut.pcfg.vimwiki')
    end,
    config = function()
      require('walnut.pcfg.vimwiki').config()
    end,
    requires = {
      'skywind3000/vim-quickui',
    }
  }

  use {
    'dstein64/nvim-scrollview',
    setup = function()
      vim.g.scrollview_on_startup = 1
      vim.g.scrollview_current_only = 1
      vim.g.scrollview_auto_workarounds = 1
      vim.g.scrollview_nvim_14040_workaround = 1
    end
  }
end)
