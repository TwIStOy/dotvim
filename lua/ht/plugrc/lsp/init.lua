return {
  {
    'folke/trouble.nvim',
    dependencies = { 'folke/lsp-colors.nvim' },
    lazy = true,
    cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle<CR>', desc = 'toggle-trouble-window' },
      {
        '<leader>xw',
        '<cmd>TroubleToggle workspace_diagnostics<CR>',
        desc = 'workspace-diagnostics',
      },
      {
        '<leader>xd',
        '<cmd>TroubleToggle document_diagnostics<CR>',
        desc = 'document-diagnostics',
      },
    },
  },

  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = { separator = " ", highlight = true, depth_limit = 5 },
  },

  {
    'glepnir/lspsaga.nvim',
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = { quit = { "q", '<Esc>' }, exec = "<CR>" },
        },
        lightbulb = { enable = false },
        symbol_in_winbar = { enable = false },
      })
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },

  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        'simrat39/symbols-outline.nvim',
        cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen', 'SymbolsOutlineClose' },
      },
      { 'p00f/clangd_extensions.nvim', lazy = true },
      { 'simrat39/rust-tools.nvim', lazy = true },
      'SmiteshP/nvim-navic',
      'onsails/lspkind.nvim',
      'hrsh7th/nvim-cmp',
      'MunifTanjim/nui.nvim',
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = require'ht.plugrc.lsp.config'.config,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require 'null-ls'
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup {
        sources = {
          diagnostics.cpplint.with {
            command = vim.g.python3_host_prog,
            args = { '-m', 'cpplint', '$FILENAME' },
          },
          diagnostics.cppcheck,
          formatting.clang_format.with {
            command = vim.g.compiled_llvm_clang_directory .. '/bin/clang-format',
          },
          formatting.lua_format,
          formatting.rustfmt,
          formatting.prettier,
        },
      }
    end,
  },

  {
    "zbirenbaum/neodim",
    lazy = true,
    event = "LspAttach",
    config = function()
      require("neodim").setup({
        alpha = 0.75,
        blend_color = "#000000",
        update_in_insert = { enable = true, delay = 100 },
        hide = { virtual_text = true, signs = false, underline = false },
      })
    end,
  },

  {
    'dnlhc/glance.nvim',
    lazy = true,
    cmd = { 'Glance' },
    config = function()
      local glance = require 'glance'
      local actions = glance.actions

      glance.setup({
        detached = function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end,
        preview_win_opts = { cursorline = true, number = true, wrap = false },
        border = { disable = true, top_char = '―', bottom_char = '―' },
        theme = { enable = true },
        list = { width = 0.2 },
        mappings = {
          list = {
            ['j'] = actions.next,
            ['k'] = actions.previous,
            ['<Down>'] = false,
            ['<Up>'] = false,
            ['<Tab>'] = actions.next_location,
            ['<S-Tab>'] = actions.previous_location,
            ['<C-u>'] = actions.preview_scroll_win(5),
            ['<C-d>'] = actions.preview_scroll_win(-5),
            ['v'] = false,
            ['s'] = false,
            ['t'] = false,
            ['<CR>'] = actions.jump,
            ['o'] = false,
            ['<leader>l'] = false,
            ['q'] = actions.close,
            ['Q'] = actions.close,
            ['<Esc>'] = actions.close,
          },
          preview = {
            ['Q'] = actions.close,
            ['<Tab>'] = false,
            ['<S-Tab>'] = false,
            ['<leader>l'] = false,
          },
        },
        folds = { fold_closed = '', fold_open = '', folded = false },
        indent_lines = { enable = false },
        winbar = { enable = true },
        hooks = {
          before_open = function(results, open, jump, method)
            if method == 'references' or method == 'implementations' then
              open(results)
            elseif #results == 1 then
              jump(results[1])
            else
              open(results)
            end
          end,
        },
      })
    end,
  },
}
