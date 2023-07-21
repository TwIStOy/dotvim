return {
  {
    "jake-stewart/jfind.nvim",
    branch = "2.0",
    enabled = false,
    config = function()
      local jfind = require("jfind")
      local key = require("jfind.key")

      jfind.setup {
        exclude = {
          ".git",
          ".idea",
          ".vscode",
          ".sass-cache",
          ".class",
          "__pycache__",
          "node_modules",
          "target",
          "build",
          "tmp",
          "assets",
          "dist",
          "public",
          "*.iml",
          "*.meta",
        },
        windowBorder = true,
        tmux = true,
      }

      -- fuzzy file search can be started simply with
      vim.keymap.set("n", "<c-f>", jfind.findFile)

      -- or you can provide more customization
      -- for more information, read the "Lua Jfind Interface" section
      vim.keymap.set("n", "<c-f>", function()
        jfind.findFile {
          formatPaths = true,
          hidden = true,
          queryPosition = "top",
          preview = true,
          previewPosition = "right",
          callback = {
            [key.DEFAULT] = vim.cmd.edit,
            [key.CTRL_S] = vim.cmd.split,
            [key.CTRL_V] = vim.cmd.vsplit,
          },
        }
      end)

      -- make sure to rebuld jfind if you want live grep
      vim.keymap.set("n", "<leader><c-f>", function()
        jfind.liveGrep {
          exclude = { "*.hpp" }, -- overrides setup excludes
          hidden = true, -- grep hidden files/directories
          caseSensitivity = "smart", -- sensitive, insensitive, smart
          --     will use vim settings by default
          preview = true,
          previewPosition = "top",
          callback = {
            [key.DEFAULT] = jfind.editGotoLine,
            [key.CTRL_B] = jfind.splitGotoLine,
            [key.CTRL_N] = jfind.vsplitGotoLine,
          },
        }
      end)
    end,
  },
}
