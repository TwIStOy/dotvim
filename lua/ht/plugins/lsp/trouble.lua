return {
  Use {
    "folke/trouble.nvim",
    lazy = {
      dependencies = { "folke/lsp-colors.nvim" },
      lazy = true,
      cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
    },
    functions = {
      FuncSpec("Toggle trouble window", "TroubleToggle", {
        keys = "<leader>xx",
        desc = "toggle-trouble-window",
      }),
      {
        filter = {
          ---@param buffer VimBuffer
          filter = function(buffer)
            return buffer:lsp_attached()
          end,
        },
        values = {
          FuncSpec(
            "Open diagnostics in current workspace (Trouble)",
            "Trouble workspace_diagnostics",
            {
              keys = "<leader>xw",
              desc = "lsp-references",
            }
          ),
          FuncSpec(
            "Open diagnostics in current document (Trouble)",
            "Trouble document_diagnostics",
            {
              keys = "<leader>xd",
              desc = "lsp-references",
            }
          ),
        },
      },
    },
  },
}
