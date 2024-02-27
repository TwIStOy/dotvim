---@type dora.core.plugin.PluginOptions[]
return {
  {
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
        require("bufferline").cycle(1)
        local bufnr = vim.api.nvim_get_current_buf()
        for _, window in ipairs(windows) do
          vim.api.nvim_win_Set_buf(window, bufnr)
        end
      end,
    },
    actions = function()
      ---@type dora.core.action
      local action = require("dora.lib.action")

      local function redraw_all()
        vim.api.nvim_command("redrawstatus!")
        vim.api.nvim_command("redraw!")
      end

      return action.make_options {
        from = "close-buffers",
        category = "CloseBuffer",
        actions = {
          {
            id = "close-buffer.delete-all-hidden-buffers",
            callback = function()
              require("close_buffers").delete { type = "hidden", force = true }
              redraw_all()
            end,
            keys = { "<leader>ch", desc = "delete-hidden-buffers" },
          },
          {
            id = "close-buffer.delete-all-buffers-without-name",
            callback = function()
              require("close_buffers").delete { type = "nameless" }
              redraw_all()
            end,
          },
          {
            id = "close-buffer.delete-current-buffer",
            callback = function()
              require("close_buffers").delete { type = "this" }
              redraw_all()
            end,
          },
          {
            id = "close-buffer.delete-all-buffers-matching-the-regex",
            callback = function()
              vim.ui.input({ prompt = "Regex" }, function(input)
                if input ~= nil and #input > 0 then
                  require("close_buffers").delete { regex = input }
                end
              end)
              redraw_all()
            end,
          },
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "folke/lsp-colors.nvim", "telescope.nvim" },
    cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
    opts = { use_diagnostic_signs = true },
    actions = function()
      ---@type dora.core.action
      local action = require("dora.lib.action")

      local lsp_actions = action.make_options {
        from = "trouble.nvim",
        category = "Trouble",
        condition = function(buffer)
          return #buffer.lsp_servers > 0
        end,
        actions = {
          {
            id = "trouble.open-workspace-diagnostic",
            callback = "Trouble workspace_diagnostic",
            keys = { "<leader>xw", desc = "lsp-workspace-diagnostic" },
          },
          {
            id = "trouble.open-document-diagnostic",
            callback = "Trouble document_diagnostic",
            keys = { "<leader>xd", desc = "lsp-document-diagnostic" },
          },
        },
      }

      local common_actions = action.make_options {
        from = "trouble.nvim",
        category = "Trouble",
        actions = {
          {
            id = "trouble.toggle-window",
            callback = "TroubleToggle",
            keys = { "<leader>xx", desc = "trouble-toggle" },
          },
        },
      }

      local actions_in_trouble_window = action.make_options {
        from = "trouble.nvim",
        category = "Trouble",
        condition = function()
          return require("trouble").is_open()
        end,
        actions = {
          {
            id = "trouble.previous-trouble",
            callback = function()
              require("trouble").previous { skip_groups = true, jump = true }
            end,
            keys = { "[q", desc = "previous-trouble" },
          },
          {
            id = "trouble.next-trouble",
            callback = function()
              require("trouble").next { skip_groups = true, jump = true }
            end,
            keys = { "]q", desc = "next-trouble" },
          },
        },
      }

      return {
        unpack(lsp_actions),
        unpack(common_actions),
        unpack(actions_in_trouble_window),
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = { "nvim-lua/plenary.nvim", "telescope.nvim", "trouble.nvim" },
    opts = {
      highlight = { keyword = "wide_bg", pattern = "(KEYWORDS)\\([^)]*\\):" },
      search = { pattern = "(KEYWORDS)\\([^)]*\\):" },
      keywords = {
        HACK = { alt = { "UNSAFE" } },
        FIX = { alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "FUCKING" } },
      },
    },
    actions = function()
      ---@type dora.core.action
      local action = require("dora.lib.action")

      return action.make_options {
        from = "todo-comments.nvim",
        category = "TodoComments",
        actions = {
          {
            id = "todo-comments.open-todos-in-trouble",
            title = "Open todos in trouble",
            callback = "TodoTrouble",
            keys = "<leader>xt",
            description = "touble-todo",
          },
          {
            id = "todo-comments.open-todos-fix-fixme-in-trouble",
            title = "Open todos,fix,fixme in trouble",
            callback = "TodoTrouble keywords=TODO,FIX,FIXME",
            keys = "<leader>xT",
            description = "trouble-TFF",
          },
          {
            id = "todo-comments.list-all-todos-in-telescope",
            title = "List all todos in telescope",
            callback = "TodoTelescope",
            keys = "<leader>lt",
            description = "list-todos",
          },
          {
            id = "todo-comments.goto-next-todo",
            title = "Goto next todo",
            callback = function()
              require("todo-comments").jump_next()
            end,
            keys = "]t",
            description = "jump-next-todo",
          },
          {
            id = "todo-comments.goto-previous-todo",
            title = "Goto previous todo",
            callback = function()
              require("todo-comments").jump_prev()
            end,
            keys = "[t",
            description = "jump-prev-todo",
          },
        },
      }
    end,
  },
}
