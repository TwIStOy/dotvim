---@type LazyPluginSpec
return {
  "kazhala/close-buffers.nvim",
  cmd = {
    "BDelete",
    "BWipeout",
  },
  opts = {
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
      ---@diagnostic disable-next-line: undefined-field
      require("bufferline").cycle(1)
      local bufnr = vim.api.nvim_get_current_buf()
      for _, window in ipairs(windows) do
        vim.api.nvim_win_set_buf(window, bufnr)
      end
    end,
  },
  keys = function()
    local function redraw_all()
      vim.api.nvim_command("redrawstatus!")
      vim.api.nvim_command("redraw!")
    end
    return {
      {
        "<leader>ch",
        function()
          require("close_buffers").delete { type = "hidden", force = true }
          redraw_all()
        end,
        desc = "delete-hidden-buffers",
        mode = { "n", "v" },
      },
    }
  end,
}
