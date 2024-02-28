---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.ui",
  deps = {},
  plugins = {
    {
      "folke/drop.nvim",
      event = "VimEnter",
      cond = function()
        return vim.fn.argc() == 0
      end,
      opts = {
        theme = "snow",
        screensaver = false,
      },
    },
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
