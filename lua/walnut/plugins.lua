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
cmd('autocmd BufWritePost */walnut/plugins.lua PackerCompile')

local pkr = require('packer')
pkr.init({
  ensure_dependencies = true,
  display = {
    auto_clean = false
  }
})

pkr.startup(function(use)
  use { 'skywind3000/asyncrun.vim', cmd = {'AsyncRun', 'AsyncStop'} }

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

  use 'skywind3000/vim-quickui'

  -- text-objects
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

  use 'tpope/vim-surround'

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.api.nvim_set_var('surround_no_mappings', 0)
      vim.api.nvim_set_var('surround_no_insert_mappings', 1)
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'c', 'cpp'
        },
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {},  -- list of language that will be disabled
        },
      }
    end
  }

  use {
    'Yggdroot/LeaderF',
    cmd = { 'Leaderf', 'LeaderfFile', 'LeaderfBuffer', 'LeaderfBufferAll',
            'LeaderfMru', 'LeaderfMruCwd', 'LeaderfTag', 'LeaderfBufTag',
            'LeaderfBufTagAll', 'LeaderfFunction', 'LeaderfFunctionAll',
            'LeaderfLine', 'LeaderfLineAll', 'LeaderfHistoryCmd',
            'LeaderfHistorySearch', 'LeaderfSelf', 'LeaderfHelp',
            'LeaderfColorscheme', 'LeaderfRgInteractive', 'LeaderfRgRecall' },
    run = './install.sh',
    setup = function() require('walnut.pcfg.leaderf') end
  }

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
      require('bufferline').setup{}
      vim.api.nvim_set_keymap('n', '[b', ':BufferLineCyclePrev<CR>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', ']b', ':BufferLineCycleNext<CR>', { silent = true, noremap = true })
    end
  }

  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    requires = {
      'kyazdani42/nvim-web-devicons'
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
    cmd = { 'Bdelete' }
  }

  use {
    'aperezdc/vim-template',
    config = function() require('walnut.pcfg.template') end
  }

  use {
    'tomtom/tcomment_vim',
    setup = function()
      vim.api.nvim_set_var('tcomment_maps', 0)
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
end)
