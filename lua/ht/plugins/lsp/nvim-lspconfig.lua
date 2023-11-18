return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "simrat39/symbols-outline.nvim",
      {
        "p00f/clangd_extensions.nvim",
        lazy = true,
      },
      { "simrat39/rust-tools.nvim", lazy = true },
      "SmiteshP/nvim-navic",
      "onsails/lspkind.nvim",
      "hrsh7th/nvim-cmp",
      "williamboman/mason.nvim",
      "MunifTanjim/nui.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      --- add menus for specific types
      local LSP = require("ht.with_plug.lsp")
      local RightClick = require("ht.core.right-click")
      local FF = require("ht.core.functions")

      local on_buffer_attach = require("ht.conf.lsp.on_attach")

      vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = false,
          severity_sort = true,
          signs = true,
          update_in_insert = false,
          underline = true,
        })

      local capabilities = LSP.client_capabilities()

      local signs =
        { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- force utf16 only
      capabilities.offsetEncoding = { "utf-16" }

      local lsp_conf = require("ht.conf.lsp.init")

      for _, server in ipairs(lsp_conf.all_servers) do
        if server.setup ~= nil then
          server.setup(on_buffer_attach, capabilities)
        end

        if server.right_click ~= nil then
          for _, section in ipairs(server.right_click) do
            RightClick.add_section(section)
          end
        end
        if server.function_sets ~= nil then
          for _, set in ipairs(server.function_sets) do
            FF:add_function_set(set)
          end
        end
      end
      for _, server in ipairs(require("htts").AllLspServers) do
        server:setup(on_buffer_attach, capabilities)
      end
      require("ht.conf.lsp.servers.default")()
    end,
  },
}
