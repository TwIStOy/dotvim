---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "chrishrb/gx.nvim",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "browse-current" },
    },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    opts = {
      handlers = {
        plugin= true,
        rust = { -- custom handler to open rust's cargo packages
          filetype = { "toml" },
          filename = "Cargo.toml",
          handle = function(mode, line, _)
            local crate = require("gx.helper").find(line, mode, "([%w_-]+)%s-=%s")
            if crate then
              return "https://docs.rs/" .. crate
            end
          end,
        },
      },
    },
  },
}
