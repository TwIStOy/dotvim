---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.ui",
  deps = {},
  plugins = {
    {
      "NvChad/nvim-colorizer.lua",
      ft = { "vim", "lua" },
      cmd = {
        "ColorizerAttachToBuffer",
        "ColorizerDetachFromBuffer",
        "ColorizerReloadAllBuffers",
        "ColorizerToggle",
      },
      opts = {
        filetypes = { "vim", "lua" },
        user_default_options = {
          RRGGBB = true,
          names = false,
          AARRGGBB = true,
          mode = "virtualtext",
        },
      },
      config = function(_, opts)
        require("colorizer").setup(opts)

        local ft = vim.api.nvim_get_option_value("filetype", {
          buf = 0,
        })
        if ft == "vim" or ft == "lua" then
          require("colorizer").attach_to_buffer(0)
        end
      end,
    },
  },
}
