return {
  Use {
    "williamboman/mason.nvim",
    lazy = {
      build = ":MasonUpdate",
      lazy = true,
      cmd = {
        "Mason",
        "MasonUpdate",
        "MasonInstall",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
      },
      event = {
        "VeryLazy",
      },
      opts = {
        PATH = "skip",
      },
      config = function(_, opts)
        vim.defer_fn(function()
          require("mason").setup(opts)

          local registry = require("mason-registry")
          local lsp_conf = require("ht.conf.lsp.init")
          for _, pkg_spec in ipairs(lsp_conf.mason_packages) do
            local pkg = registry.get_package(pkg_spec.name)
            if not pkg:is_installed() then
              local install_opts = nil
              if pkg_spec.version ~= nil then
                install_opts = {
                  version = pkg_spec.version,
                }
              end
              local handle = pkg:install(install_opts)
              handle:once(
                "closed",
                vim.schedule_wrap(function()
                  if pkg:is_installed() then
                    vim.notify(("%s was successfully installed"):format(pkg))
                  else
                    vim.notify(
                      ("failed to install %s"):format(pkg),
                      vim.log.levels.ERROR
                    )
                  end
                end)
              )
            end
          end
        end, 100)
      end,
    },
    functions = require("ht.plug_features.mason"),
  },
}
