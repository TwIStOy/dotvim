return {
  Use {
    "williamboman/mason.nvim",
    lazy = {
      build = ":MasonUpdate",
      opts = {
        PATH = "skip",
      },
      config = function(_, opts)
        require("mason").setup(opts)

        local registry = require("mason-registry")
        local lsp_conf = require("ht.conf.lsp.init")
        for _, package_name in ipairs(lsp_conf.mason_packages) do
          local pkg = registry.get_package(package_name)
          if not pkg:installed() then
            local handle = pkg:install()
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
      end,
    },
    functions = require("ht.plug_features.mason"),
  },
}
