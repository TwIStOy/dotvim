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
    },
    config = require'ht.plugrc.lsp.config'.config,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup { sources = { null_ls.builtins.diagnostics.cpplint } }
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
