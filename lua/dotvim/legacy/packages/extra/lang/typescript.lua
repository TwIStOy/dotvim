---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.typescript",
  deps = {
    "dora.packages.coding",
    "dora.packages.lsp",
    "dora.packages.treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "typescript" })
        end
      end,
    },
    {
      "pmizio/typescript-tools.nvim",
      lazy = true,
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      cmd = {
        "TSToolsOrganizeImports",
        "TSToolsSortImports",
        "TSToolsRemoveUnusedImports",
        "TSToolsRemoveUnused",
        "TSToolsAddMissingImports",
        "TSToolsFixAll",
        "TSToolsGoToSourceDefinition",
        "TSToolsRenameFile",
      },
      actions = function()
        ---@type dora.core.action
        local action = require("dora.core.action")

        return action.make_options {
          from = "typescript-tools.nvim",
          category = "TSTools",
          actions = {
            {
              id = "typescript-tools.organize-imports",
              title = "Sorts and removes unused imports",
              callback = "TSToolsOrganizeImports",
            },
            {
              id = "typescript-tools.sort-imports",
              title = "Sorts imports",
              callback = "TSToolsSortImports",
            },
            {
              id = "typescript-tools.remove-unused-imports",
              title = "Removes unused imports",
              callback = "TSToolsRemoveUnusedImports",
            },
            {
              id = "typescript-tools.remove-unused",
              title = "Removes all unused statements",
              callback = "TSToolsRemoveUnused",
            },
            {
              id = "typescript-tools.add-missing-imports",
              title = "Adds imports for all statements that lack one and can be imported",
              callback = "TSToolsAddMissingImports",
            },
            {
              id = "typescript-tools.fix-all",
              title = "Fixes all fixable erros in the current file",
              callback = "TSToolsFixAll",
            },
            {
              id = "typescript-tools.go-to-source-definition",
              title = "Go to the source definition",
              callback = "TSToolsGoToSourceDefinition",
            },
            {
              id = "typescript-tools.rename-file",
              title = "Rename file and apply changes to connected files",
              callback = "TSToolsRenameFile",
            },
          },
        }
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            typescript = {
              settings = {
                tsserver_locale = "en",
                complete_function_calls = true,
              },
            },
          },
          setup = {
            typescript = function(_, server_opts)
              require("typescript-tools").setup(server_opts)
            end,
          },
        },
      },
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          typescript = { "prettier" },
        },
      },
    },
  },
}
