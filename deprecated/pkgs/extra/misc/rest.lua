---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.rest",
  deps = {
    "editor",
    "treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, {
            "lua",
            "xml",
            "http",
            "json",
            "graphql",
          })
        end
      end,
    },
    {
      "mistweaverco/kulala.nvim",
      dependencies = {
        "telescope.nvim",
      },
      ft = { "http" },
      opts = function()
        ---@type dotvim.utils
        local Utils = require("dotvim.utils")

        local xmllint = Utils.which("xmllint")
        return {
          formatters = {
            json = { "jq", "." },
            xml = { xmllint, "--format", "-" },
            html = { xmllint, "--format", "--html", "-" },
          },
          icons = {
            inlay = {
              loading = "󰔟",
              done = "󰄲",
            },
          },
          additional_curl_options = { "--insecure" },
        }
      end,
      config = true,
    },
  },
}
