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
      {
        ']e',
        function()
          require('trouble').next { skip_groups = true, jump = true }
        end,
        desc = "jump-to-next-diagnostic",
      },
      {
        '[e',
        function()
          require('trouble').previous { skip_groups = true, jump = true }
        end,
        desc = "jump-to-previous-diagnostic",
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
      require'ht.core.lsp'.on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = { separator = " ", highlight = true, depth_limit = 5 },
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
}
