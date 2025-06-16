---@module "dotvim.plugins.lsp"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    enabled = function()
      return not Commons.nix.in_nix_env() and not vim.g.vscode
    end,
    opts = function(_, opts)
      return Commons.option.deep_merge(opts, {
        PATH = "append",
        ui = {
          icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ",
          },
        },
        extra = {
          outdated_check_interval = 1, -- in days
          ensure_installed = {
            "gh",
          },
          update_installed_packages = true,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function(_, opts)
      for lsp, config in pairs(opts.lsp_configs or {}) do
        vim.lsp.config(lsp, config)
        vim.lsp.enable(lsp)
      end
    end,
  },
}
