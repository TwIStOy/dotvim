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
  {
    "monaqa/dial.nvim",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      local augend = require("dial.augend")

      local function define_custom(...)
        return augend.constant.new({
          elements = { ... },
          word = true,
          cyclic = true,
        })
      end

      opts = opts or {}
      opts.language_configs = opts.language_configs or {}

      opts.language_configs.cpp = {
        define_custom("Debug", "Info", "Warn", "Error", "Fatal"),
        define_custom("first", "second"),
        define_custom("true_type", "false_type"),
        define_custom("uint8_t", "uint16_t", "uint32_t", "uint64_t"),
        define_custom("int8_t", "int16_t", "int32_t", "int64_t"),
        define_custom("htonl", "ntohl"),
        define_custom("htons", "ntohs"),
      }

      opts.language_configs.c = {
        define_custom("Debug", "Info", "Warn", "Error", "Fatal"),
        define_custom("uint8_t", "uint16_t", "uint32_t", "uint64_t"),
        define_custom("int8_t", "int16_t", "int32_t", "int64_t"),
        define_custom("htonl", "ntohl"),
        define_custom("htons", "ntohs"),
      }

      return opts
    end,
  },
}
