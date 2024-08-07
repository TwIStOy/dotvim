---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "Bekaboo/deadcolumn.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      scope = "visible",
      modes = function(mode)
        return mode:find("^[iRss\x13]") ~= nil
      end,
      extra = {
        follow_tw = "+1",
      },
    },
  },
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
          vim.api.nvim_win_set_buf(window, bufnr)
        end
      end,
    },
    actions = function()
      ---@type dotvim.core.action
      local action = require("dotvim.core.action")

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
            title = "Delete all hidden buffers",
            callback = function()
              require("close_buffers").delete { type = "hidden", force = true }
              redraw_all()
            end,
            keys = { "<leader>ch", desc = "delete-hidden-buffers" },
          },
          {
            id = "close-buffer.delete-all-buffers-without-name",
            title = "Delete all buffers without name",
            callback = function()
              require("close_buffers").delete { type = "nameless" }
              redraw_all()
            end,
          },
          {
            id = "close-buffer.delete-current-buffer",
            title = "Delete current buffer",
            callback = function()
              require("close_buffers").delete { type = "this" }
              redraw_all()
            end,
          },
          {
            id = "close-buffer.delete-all-buffers-matching-the-regex",
            title = "Delete all buffers matching the regex",
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
    opts = { use_diagnostic_signs = true, auto_preview = false },
    actions = function()
      ---@type dotvim.core.action
      local action = require("dotvim.core.action")

      local lsp_actions = action.make_options {
        from = "trouble.nvim",
        category = "Trouble",
        condition = function(buffer)
          return #buffer.lsp_servers > 0
        end,
        actions = {
          {
            id = "trouble.open-workspace-diagnostic",
            title = "Open workspace diagnostic",
            callback = "Trouble workspace_diagnostic",
            keys = { "<leader>xw", desc = "lsp-workspace-diagnostic" },
          },
          {
            id = "trouble.open-document-diagnostic",
            title = "Open document diagnostic",
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
            title = "Toggle trouble window",
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
            title = "Previous trouble",
            callback = function()
              require("trouble").previous { skip_groups = true, jump = true }
            end,
            keys = { "[q", desc = "previous-trouble" },
          },
          {
            id = "trouble.next-trouble",
            title = "Next trouble",
            callback = function()
              require("trouble").next { skip_groups = true, jump = true }
            end,
            keys = { "]q", desc = "next-trouble" },
          },
        },
      }

      local ret = {}
      vim.list_extend(ret, lsp_actions)
      vim.list_extend(ret, common_actions)
      vim.list_extend(ret, actions_in_trouble_window)
      return ret
    end,
  },
  {
    "TwIStOy/todo-comments.nvim",
    event = "BufReadPost",
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = { "nvim-lua/plenary.nvim", "telescope.nvim", "trouble.nvim" },
    opts = {
      highlight = { keyword = "wide_bg", pattern = "(KEYWORDS)\\([^)]*\\):" },
      search = { pattern = "(KEYWORDS)\\([^)]*\\):" },
      keywords = {
        HACK = { alt = { "UNSAFE", 'SAFETY' } },
        FIX = { alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "FUCKING" } },
      },
    },
    actions = function()
      ---@type dotvim.core.action
      local action = require("dotvim.core.action")

      return action.make_options {
        from = "todo-comments.nvim",
        category = "TodoComments",
        actions = {
          {
            id = "todo-comments.open-todos-in-trouble",
            title = "Open todos in trouble",
            callback = "TodoTrouble",
            keys = { "<leader>xt", desc = "trouble-todo" },
          },
          {
            id = "todo-comments.open-todos-fix-fixme-in-trouble",
            title = "Open todos,fix,fixme in trouble",
            callback = "TodoTrouble keywords=TODO,FIX,FIXME",
            keys = { "<leader>xT", desc = "trouble-TFF" },
          },
          {
            id = "todo-comments.list-all-todos-in-telescope",
            title = "List all todos in telescope",
            callback = "TodoTelescope",
            keys = { "<leader>lt", desc = "list-todos" },
          },
          {
            id = "todo-comments.goto-next-todo",
            title = "Goto next todo",
            callback = function()
              require("todo-comments").jump_next()
            end,
            keys = { "]t", desc = "jump-next-todo" },
          },
          {
            id = "todo-comments.goto-previous-todo",
            title = "Goto previous todo",
            callback = function()
              require("todo-comments").jump_prev()
            end,
            keys = { "[t", desc = "jump-previous-todo" },
          },
        },
      }
    end,
  },
  {
    "echasnovski/mini.move",
    gui = "all",
    opts = {
      mappings = {
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",
        line_left = "<C-h>",
        line_right = "<C-l>",
        line_down = "<C-j>",
        line_up = "<C-k>",
      },
    },
    keys = {
      { "<C-h>", mode = { "n", "v" } },
      { "<C-j>", mode = { "n", "v" } },
      { "<C-k>", mode = { "n", "v" } },
      { "<C-l>", mode = { "n", "v" } },
    },
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "<", close = ">" },
      },
    },
    keys = {
      {
        "<M-x>",
        "<Plug>(TaboutMulti)",
        mode = "i",
        silent = true,
      },
      {
        "<M-z>",
        "<Plug>(TaboutBackMulti)",
        mode = "i",
        silent = true,
      },
    },
  },
  {
    "aperezdc/vim-template",
    cmd = { "Template", "TemplateHere" },
    init = function()
      vim.g.templates_directory = {
        vim.fn.stdpath("config") .. "/templates",
      }
      vim.g.templates_no_autocmd = 0
      vim.g.templates_debug = 0
      vim.g.templates_no_builtin_templates = 1
    end,
    gui = "all",
    actions = function()
      ---@type dotvim.core.action
      local action = require("dotvim.core.action")
      ---@type dotvim.core
      local Core = require("dotvim.core")

      return action.make_options {
        from = "vim-template",
        category = "Template",
        actions = {
          {
            id = "template.expand-template-into-current-buffer",
            title = "Expand template into current buffer",
            callback = Core.input_then_exec("Template"),
            description = "Expand a mated template fron the beginning of the buffer",
          },
          {
            id = "template.expand-template-under-cursor",
            title = "Expand template under cursor",
            callback = Core.input_then_exec("TemplateHere"),
            description = "Expand a matched template under the cursor",
          },
        },
      }
    end,
  },
  {
    "TwIStOy/nvim-lastplace",
    event = "BufReadPre",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = false,
    },
  },
  {
    "wakatime/vim-wakatime",
    event = "BufReadPost",
    opts = {},
    config = function() end,
  },
  {
    "skywind3000/asynctasks.vim",
    enabled = true,
    cmd = {
      "AsyncTask",
      "AsyncTaskMacro",
      "AsyncTaskProfile",
      "AsyncTaskEdit",
    },
    init = function()
      vim.g.asyncrun_open = 10
      vim.g.asyncrun_bell = 0
      vim.g.asyncrun_rootmarks = {
        "BLADE_ROOT",
        "JK_ROOT",
        "WORKSPACE",
        ".buckconfig",
        "CMakeLists.txt",
      }
      vim.g.asynctasks_extra_config =
        { "~/.dotfiles/dots/tasks/asynctasks.ini" }
    end,
    dependencies = {
      { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },
    },
  },
  {
    "topaxi/gh-actions.nvim",
    enabled = false,
    name = "gh-actions.nvim",
    pname = "gh-actions-nvim",
    cmd = { "GhActions" },
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    build = "make",
    opts = {},
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    opts = {
      default_remote = { "origin", "upstream" },
    },
  },
  {
    "edkolev/tmuxline.vim",
    cmd = { "Tmuxline" },
  },
}
