return {
  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = { separator = " ", highlight = true, depth_limit = 5 },
  },

  {
    "TwIStOy/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("lspsaga").setup {
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = { quit = { "q", "<Esc>" }, exec = "<CR>" },
        },
        lightbulb = { enable = false },
        symbol_in_winbar = { enable = false },
      }
    end,
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "simrat39/symbols-outline.nvim",
        cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
      },
      {
        "p00f/clangd_extensions.nvim",
        lazy = true,
      },
      { "simrat39/rust-tools.nvim", lazy = true },
      "SmiteshP/nvim-navic",
      "onsails/lspkind.nvim",
      "hrsh7th/nvim-cmp",
      "MunifTanjim/nui.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("ht.plugrc.lsp.config").config()
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local MASON = require("ht.with_plug.mason")

      null_ls.setup {
        sources = {
          formatting.clang_format.with {
            command = MASON.bin("clang-format")[1],
          },
          formatting.stylua.with {
            command = MASON.bin("stylua")[1],
            condition = function(utils)
              return utils.root_has_file { "stylua.toml", ".stylua.toml" }
            end,
          },
          formatting.rustfmt,
          formatting.prettier.with {
            command = MASON.bin("prettier")[1],
          },
          formatting.black.with {
            command = MASON.bin("black")[1],
          },
        },
      }
    end,
  },
}
