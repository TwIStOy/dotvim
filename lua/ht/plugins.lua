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

local packer_init_config = {
  ensure_dependencies = true,
  opt_default = false,
  transitive_opt = false,
  display = {
    auto_clean = false,
    open_fn = function()
      return require('packer.util').float { border = 'single' }
    end,
  },
  profile = { enable = true, threshold = 1 },
  compile_path = util.join_paths(vim.fn.stdpath('config'), 'lua',
                                 'packer_compiled.lua'),
}

if vim.loop.os_uname().sysname == 'Darwin' then
  packer_init_config.max_jobs = 6
end

pkr.init(packer_init_config)

local loader
pkr.startup(function(use)
  loader = require'ht.plugins.init'.loader:new(use)
  local mod = require'ht.plugins.init'.use_mod(use)

  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use 'kyazdani42/nvim-web-devicons'

  use 'nvim-lua/plenary.nvim'

  use { 'nvim-lua/popup.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  mod 'ui'

  loader:setup 'asynctasks'

  loader:setup 'nvim_tree'

  loader:setup 'diffview'

  loader:setup 'telescope'

  loader:setup 'lastplace'

  loader:setup 'alpha'

  loader:setup 'whichkey'

  loader:setup 'textobject'

  loader:setup 'ultisnips'

  loader:setup 'leaderf'

  loader:setup 'vim_cpp_toolkit'

  loader:setup 'toggleterm'

  loader:setup 'conflict_resolve'

  loader:setup 'surround'

  -- NOTE(hawtian): maybe performance problem
  loader:setup 'indent_guide'

  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        styles = {
          comments = { "italic" },
          properties = { "italic" },
          functions = { "italic", "bold" },
          keywords = { "italic" },
          operators = { "bold" },
          conditionals = { "bold" },
          loops = { "bold" },
          booleans = { "bold", "italic" },
          numbers = {},
          types = {},
          strings = {},
          variables = {},
        },
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          navic = { enabled = true, custom_bg = "NONE" },
          lsp_trouble = true,
          gitsigns = true,
          telescope = true,
          nvimtree = true,
          which_key = true,
          indent_blankline = { enabled = true, colored_indent_levels = false },
          hop = true,
          cmp = true,
          dap = true,
          fidget = true,
        },
      }

      vim.cmd 'colorscheme catppuccin'
    end,
  }

  --[[
  use {
    'katawful/kat.nvim',
    tag = '3.1',
    config = function()
      vim.cmd 'colorscheme kat.nvim'
    end,
  }
  --]]

  --[[
  use {
    'uloco/bluloco.nvim',
    requires = { 'rktjmp/lush.nvim' },
    config = function()
      require("bluloco").setup({
        style = "auto",
        transparent = false,
        italics = false,
      })
      vim.cmd('colorscheme bluloco')
    end,
  }
  --]]

  --[[
  use {
    "clpi/cyu.lua",
    config = function()
      vim.g.cayu_style = "night"
      vim.g.cayu_italic_functions = true
      vim.g.cayu_sidebars = {
        'nvim_tree',
        "qf",
        "vista_kind",
        "terminal",
        "packer",
      }

      vim.cmd'colorscheme cayu'
    end,
  }
  --]]

  --[[
  use {
    'luisiacc/gruvbox-baby',
    branch = 'main',
    config = function()
      vim.cmd 'colorscheme gruvbox-baby'
    end,
  }
  --]]

  --[[
  use {
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      })

      vim.cmd("colorscheme nightfox")
    end,
  }
  --]]

  loader:setup 'possession'

  -- loader:setup 'cphelper'

  use { 'MTDL9/vim-log-highlighting', event = 'BufNewFile,BufRead *.log' }

  use { 'nacro90/numb.nvim', opt = true, config = [[require('numb').setup()]] }

  use { 'wakatime/vim-wakatime', event = 'BufRead' }

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

  use {
    "nvim-zh/colorful-winsep.nvim",
    config = function()
      require('colorful-winsep').setup()
    end,
  }

  use { 'Asheq/close-buffers.vim', cmd = { 'Bdelete' } }

  loader:setup 'template'

  loader:setup 'tcomment'

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
    event = 'BufReadPost',
  }

  loader:setup 'matchup'

  loader:setup 'scrollview'

  loader:setup 'hop'

  use 'rcarriga/nvim-notify'

  loader:setup 'copilot'

  -- loader:setup 'noice'

  loader:setup 'lspkind'

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
    opt = true,
    requires = {
      { 'mfussenegger/nvim-dap', opt = true },
      { 'theHamsta/nvim-dap-virtual-text', opt = true },
    },
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
  use_rocks 'middleclass'
end)

loader:setup_mappings()

return M
