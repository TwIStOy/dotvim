return {
  -- remove buffers
  Use {
    "kazhala/close-buffers.nvim",
    lazy = {
      lazy = true,
      cmd = { "BDelete", "BWipeout" },
      config = function()
        require("close_buffers").setup {
          filetype_ignore = {
            "dashboard",
            "NvimTree",
            "TelescopePrompt",
            "terminal",
            "toggleterm",
            "packer",
            "fzf",
          },
          preserve_window_layout = { "this" },
          next_buffer_cmd = function(windows)
            require("bufferline").cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()
            for _, window in ipairs(windows) do
              vim.api.nvim_win_set_buf(window, bufnr)
            end
          end,
        }
      end,
    },
    category = "CloseBuffer",
    functions = {
      FuncSpec("Delete all non-visible buffers", function()
        require("close_buffers").delete { type = "hidden", force = true }
        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end, {
        keys = "<leader>ch",
        desc = "clear-hidden-buffers",
      }),
      FuncSpec("Delete all buffers without name", function()
        require("close_buffers").delete { type = "nameless" }
        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end),
      FuncSpec("Delete the current buffer", function()
        require("close_buffers").delete { type = "this" }
        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end),
      FuncSpec("Delete all buffers matching the regex", function()
        vim.ui.input({ prompt = "Regex" }, function(input)
          if input ~= nil then
            if #input > 0 then
              require("close_buffers").delete { regex = input }
            end
          end
        end)

        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end),
    },
  },
}
