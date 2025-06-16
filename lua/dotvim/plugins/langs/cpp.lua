---@type LazyPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      return require("dotvim.commons").option.deep_merge(opts, {
        extra = {
          ensure_installed = {
            "clangd",
            "clang-format",
            "cpplint",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      lsp_configs = {
        clangd = {
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--clang-tidy",
            "--background-index",
            "--background-index-priority=normal",
            "--ranking-model=decision_forest",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--limit-references=100",
            "--include-cleaner-stdlib",
            "--all-scopes-completion",
            "-j=20",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang_format" },
        c = { "clang_format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        cpp = { "cpplint" },
        c = { "cpplint" },
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    opts = {
      memory_usage = { border = "rounded" },
      symbol_info = { border = "rounded" },
    },
    keys = {
      {
        "<leader>fa",
        function()
          vim.cmd("ClangdSwitchSourceHeader")
        end,
        desc = "switch-source-header",
        ft = { "c", "cpp" },
      },
    },
  },
}
