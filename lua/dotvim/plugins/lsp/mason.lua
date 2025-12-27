local Commons = require("dotvim.commons")

---@type LazyPluginSpec
return {
  "williamboman/mason.nvim",
  enabled = function()
    return not Commons.nix.in_nix_env() and not vim.g.vscode
  end,
  opts = function(_, opts)
    return Commons.option.deep_merge(opts, {
      install_root_dir = DOTVIM_data_root .. "/mason",
      PATH = "append",
      ui = {
        icons = {
          package_installed = " ",
          package_pending = " ",
          package_uninstalled = " ",
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
}
