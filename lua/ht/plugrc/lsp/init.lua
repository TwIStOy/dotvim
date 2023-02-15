return {
  {
    'folke/trouble.nvim',
    dependencies = { 'folke/lsp-colors.nvim' },
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
      { 'j-hui/fidget.nvim', lazy = true, opts = { window = { blend = 0 } } },
      'SmiteshP/nvim-navic',
      'onsails/lspkind.nvim',
      'hrsh7th/nvim-cmp',
      'MunifTanjim/nui.nvim',
    },
    config = require'ht.plugrc.lsp.config'.config,
  },
}
