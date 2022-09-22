local M = {}

local fn = vim.fn
local cmd = vim.cmd

local packer_install_path = fn.stdpath('data') ..
                                '/site/pack/packer/start/packer.nvim/'

local function init_packer()
  if not vim.loop.fs_stat(vim.fn.glob(packer_install_path)) then
    os.execute('git clone https://github.com/wbthomason/packer.nvim ' ..
                   packer_install_path)
  end

  cmd [[pa packer.nvim]]
end

init_packer()

local pkr = require 'packer'
local util = require 'packer.util'

pkr.init({
  ensure_dependencies = true,
  opt_default = false,
  transitive_opt = false,
  max_jobs = 4,
  display = {
    auto_clean = false,
    open_fn = function()
      return require('packer.util').float { border = 'single' }
    end,
  },
  profile = { enable = true, threshold = 1 },
  compile_path = util.join_paths(vim.fn.stdpath('config'), 'lua',
                                 'packer_compiled.lua'),
})

local loader
pkr.startup(function(use)
  loader = require'ht.plugins.init'.loader:new(use)
  local use_config = require'ht.plugins.init'.use_config
  local use_setup = require'ht.plugins.init'.use_config
  local get_mappings = require'ht.plugins.init'.get_mappings

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

  loader:setup 'conflict_resolve'

  loader:setup 'surround'

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

  loader:setup 'nvim_treesitter'

  loader:setup 'nvim_bqf'

  loader:setup 'dial'

  loader:setup 'tabular'

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

  loader:setup 'tcomment'

  loader:setup 'illuminate'

  loader:setup 'jplus'

  use 'tpope/vim-repeat'

  loader:setup 'better_whitespace'

  loader:setup 'sideways'

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
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require("todo-comments").setup {
        highlight = { keyword = 'bg', pattern = [[.*<(KEYWORDS)\([^)]*\):]] },
      }
    end,
  }

  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text' },
  }

  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  }

  loader:setup 'quickhl'

  loader:setup 'lsp'

  loader:setup 'trouble'

  loader:setup 'neogen'

  use_rocks 'lualogging'

  use_rocks 'luachild'
end)

loader:setup_mappings()

return M
