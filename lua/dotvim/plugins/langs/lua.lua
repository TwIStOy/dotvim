---@type LazyPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      return require("dotvim.commons").option.deep_merge(opts, {
        extra = {
          ensure_installed = {
            "stylua",
            "emmylua_ls",
          },
        },
      })
    end,
  },
}
