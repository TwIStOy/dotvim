return {
  {
    "nvimdev/guard.nvim",
    lazy = true,
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "GuardFmt", "GuardDisable", "GuardEnable" },
    config = function()
      local ft = require("guard.filetype")

      local formatters = require("ht.conf.external_tool.formatters")
      for _, formatter in ipairs(formatters) do
        ft(formatter.ft):fmt(formatter:export_opts())
      end

      require("guard").setup {
        fmt_on_save = false,
        -- lsp_as_default_formatter = false,
      }
    end,
    keys = {
      {
        "<leader>fc",
        function()
          vim.cmd([[GuardFmt]])
        end,
        desc = "format-file",
      },
    },
  },
}
