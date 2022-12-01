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

  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use 'kyazdani42/nvim-web-devicons'

  use 'nvim-lua/plenary.nvim'

  use { 'nvim-lua/popup.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

  -- use 'stevearc/dressing.nvim'

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

  -- NOTE(hawtian): maybe performance problem
  loader:setup 'indent_guide'

  --[[
  use {
    'projekt0n/github-nvim-theme',
    config = function()
      require("github-theme").setup {
        theme_style = 'dark',
        comment_style = "NONE",
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
      }
    end,
  }
  --]]

  --[[
  use {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup {
        style = 'storm',
        styles = { comments = {} },
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
      }
      vim.cmd 'colorscheme tokyonight'
    end,
  }
  --]]

  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        flavor = 'mocha',
        background = { light = "latte", dark = "mocha" },
        dim_inactive = {
          enabled = false,
          -- Dim inactive splits/windows/buffers.
          -- NOT recommended if you use old palette (a.k.a., mocha).
          shade = "dark",
          percentage = 0.15,
        },
        transparent_background = false,
        term_colors = true,
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
        color_overrides = {
          mocha = {
            rosewater = "#F5E0DC",
            flamingo = "#F2CDCD",
            mauve = "#DDB6F2",
            pink = "#F5C2E7",
            red = "#F28FAD",
            maroon = "#E8A2AF",
            peach = "#F8BD96",
            yellow = "#FAE3B0",
            green = "#ABE9B3",
            blue = "#96CDFB",
            sky = "#89DCEB",
            teal = "#B5E8E0",
            lavender = "#C9CBFF",

            text = "#D9E0EE",
            subtext1 = "#BAC2DE",
            subtext0 = "#A6ADC8",
            overlay2 = "#C3BAC6",
            overlay1 = "#988BA2",
            overlay0 = "#6E6C7E",
            surface2 = "#6E6C7E",
            surface1 = "#575268",
            surface0 = "#302D41",

            base = "#1E1E2E",
            mantle = "#1A1826",
            crust = "#161320",
          },
        },
        highlight_overrides = {
          mocha = function(cp)
            return {
              -- For base configs.
              CursorLineNr = { fg = cp.green },
              Search = { bg = cp.surface1, fg = cp.pink, style = { "bold" } },
              IncSearch = { bg = cp.pink, fg = cp.surface1 },

              -- For native lsp configs.
              DiagnosticVirtualTextError = { bg = cp.none },
              DiagnosticVirtualTextWarn = { bg = cp.none },
              DiagnosticVirtualTextInfo = { bg = cp.none },
              DiagnosticVirtualTextHint = { fg = cp.rosewater, bg = cp.none },

              DiagnosticHint = { fg = cp.rosewater },
              LspDiagnosticsDefaultHint = { fg = cp.rosewater },
              LspDiagnosticsHint = { fg = cp.rosewater },
              LspDiagnosticsVirtualTextHint = { fg = cp.rosewater },
              LspDiagnosticsUnderlineHint = { sp = cp.rosewater },

              -- For fidget.
              FidgetTask = { bg = cp.none, fg = cp.surface2 },
              FidgetTitle = { fg = cp.blue, style = { "bold" } },

              -- For treesitter.
              ["@field"] = { fg = cp.rosewater },
              ["@property"] = { fg = cp.yellow },

              ["@include"] = { fg = cp.teal },
              ["@operator"] = { fg = cp.sky },
              ["@keyword.operator"] = { fg = cp.sky },
              ["@punctuation.special"] = { fg = cp.maroon },

              -- ["@float"] = { fg = cp.peach },
              -- ["@number"] = { fg = cp.peach },
              -- ["@boolean"] = { fg = cp.peach },

              ["@constructor"] = { fg = cp.lavender },
              -- ["@constant"] = { fg = cp.peach },
              -- ["@conditional"] = { fg = cp.mauve },
              -- ["@repeat"] = { fg = cp.mauve },
              ["@exception"] = { fg = cp.peach },

              ["@constant.builtin"] = { fg = cp.lavender },
              -- ["@function.builtin"] = { fg = cp.peach, style = { "italic" } },
              -- ["@type.builtin"] = { fg = cp.yellow, style = { "italic" } },
              ["@variable.builtin"] = { fg = cp.red, style = { "italic" } },

              -- ["@function"] = { fg = cp.blue },
              ["@function.macro"] = { fg = cp.red, style = {} },
              ["@parameter"] = { fg = cp.rosewater },
              ["@keyword.function"] = { fg = cp.maroon },
              ["@keyword"] = { fg = cp.red },
              ["@keyword.return"] = { fg = cp.pink, style = {} },

              -- ["@text.note"] = { fg = cp.base, bg = cp.blue },
              -- ["@text.warning"] = { fg = cp.base, bg = cp.yellow },
              -- ["@text.danger"] = { fg = cp.base, bg = cp.red },
              -- ["@constant.macro"] = { fg = cp.mauve },

              -- ["@label"] = { fg = cp.blue },
              ["@method"] = { style = { "italic" } },
              ["@namespace"] = { fg = cp.rosewater, style = {} },

              ["@punctuation.delimiter"] = { fg = cp.teal },
              ["@punctuation.bracket"] = { fg = cp.overlay2 },
              -- ["@string"] = { fg = cp.green },
              -- ["@string.regex"] = { fg = cp.peach },
              -- ["@type"] = { fg = cp.yellow },
              ["@variable"] = { fg = cp.text },
              ["@tag.attribute"] = { fg = cp.mauve, style = { "italic" } },
              ["@tag"] = { fg = cp.peach },
              ["@tag.delimiter"] = { fg = cp.maroon },
              ["@text"] = { fg = cp.text },

              -- ["@text.uri"] = { fg = cp.rosewater, style = { "italic", "underline" } },
              -- ["@text.literal"] = { fg = cp.teal, style = { "italic" } },
              -- ["@text.reference"] = { fg = cp.lavender, style = { "bold" } },
              -- ["@text.title"] = { fg = cp.blue, style = { "bold" } },
              -- ["@text.emphasis"] = { fg = cp.maroon, style = { "italic" } },
              -- ["@text.strong"] = { fg = cp.maroon, style = { "bold" } },
              -- ["@string.escape"] = { fg = cp.pink },

              -- ["@property.toml"] = { fg = cp.blue },
              -- ["@field.yaml"] = { fg = cp.blue },

              -- ["@label.json"] = { fg = cp.blue },

              ["@function.builtin.bash"] = { fg = cp.red, style = { "italic" } },
              ["@parameter.bash"] = { fg = cp.yellow, style = { "italic" } },

              ["@field.lua"] = { fg = cp.lavender },
              ["@constructor.lua"] = { fg = cp.flamingo },

              ["@constant.java"] = { fg = cp.teal },

              ["@property.typescript"] = {
                fg = cp.lavender,
                style = { "italic" },
              },
              -- ["@constructor.typescript"] = { fg = cp.lavender },

              -- ["@constructor.tsx"] = { fg = cp.lavender },
              -- ["@tag.attribute.tsx"] = { fg = cp.mauve },

              ["@type.css"] = { fg = cp.lavender },
              ["@property.css"] = { fg = cp.yellow, style = { "italic" } },

              ["@property.cpp"] = { fg = cp.text },

              -- ["@symbol"] = { fg = cp.flamingo },
            }
          end,
        },
      }

      vim.cmd 'colorscheme catppuccin'
    end,
  }

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
