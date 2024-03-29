---@type dora.core.plugin.PluginOption[]
return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    opts = {
      options = {
        view = "multiwindow",
        sort_by = "insert_after_current",
        always_show_bufferline = true,
        themable = true,
        right_mouse_command = nil,
        middle_mouse_command = "bdelete! %d",
        indicator = { style = "bold" },
        hover = { enabled = true, delay = 200 },
        separator_style = "thick",
        close_command = "BDelete! %d",
        numbers = "none",
        diagnostics = "",
        show_buf_icons = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            highlight = "Directory",
          },
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            highlight = "Directory",
          },
        },
        groups = {
          options = { toggle_hidden_on_enter = true },
          items = {
            {
              name = "Tests",
              priority = 2,
              icon = "",
              matcher = function(buf)
                local ret0 = string.match(buf.name, "%_test")
                local ret1 = string.match(buf.name, "%_spec")
                return ret0 ~= nil or ret1 ~= nil
              end,
            },
          },
        },
      },
    },
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "bufferline.nvim",
        category = "Bufferline",
        actions = {
          {
            id = "bufferline.cycle-prev",
            title = "Previous buffer",
            callback = "BufferLineCyclePrev",
            keys = { "<M-,>", desc = "previous-buffer" },
          },
          {
            id = "bufferline.cycle-next",
            title = "Next buffer",
            callback = "BufferLineCycleNext",
            keys = { "<M-.>", desc = "next-buffer" },
          },
          {
            id = "bufferline.move-prev",
            title = "Move buffer left",
            callback = "BufferLineMovePrev",
            keys = { "<M-<>", desc = "move-buffer-left" },
          },
          {
            id = "bufferline.move-next",
            title = "Move buffer right",
            callback = "BufferLineMoveNext",
            keys = { "<M->>", desc = "move-buffer-right" },
          },
        },
      }
    end,
  },
}
