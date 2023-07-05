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
          filter = function()
            return require("trouble").is_open()
          end,
        },
        values = {
          FuncSpec("Previous trouble item", function()
            require("trouble").previous { skip_groups = true, jump = true }
          end, {
            keys = "[q",
            desc = "previous-trouble-item",
          }),
          FuncSpec("Next trouble item", function()
            require("trouble").next { skip_groups = true, jump = true }
          end, {
            keys = "]q",
            desc = "next-trouble-item",
          }),
        },
      },
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
