---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.misc.darwin",
  plugins = {
    {
      "mrjones2014/dash.nvim",
      build = "make install",
      cmd = { "Dash", "DashWord" },
      enabled = function()
        return vim.uv.os_uname().sysname == "Darwin"
      end,
      opts = {
        dash_app_path = "/Applications/Dash.app",
        search_engine = "google",
        file_type_keywords = {
          dashboard = false,
          NvimTree = false,
          TelescopePrompt = false,
          terminal = false,
          packer = false,
          fzf = false,
          ["neo-tree"] = false,
        },
      },
      actions = function()
        return {
          {
            id = "dash.search",
            title = "Search Dash",
            callback = function()
              vim.api.nvim_command("Dash")
            end,
          },
          {
            id = "dash.search-word",
            title = "Search Word",
            callback = function()
              vim.api.nvim_command("DashWord")
            end,
          },
        }
      end,
    },
  },
}
