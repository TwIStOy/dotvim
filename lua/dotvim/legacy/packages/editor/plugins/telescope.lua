---@type dora.core.plugin.PluginOption[]
return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    name = "telescope-fzf-native.nvim",
    lazy = true,
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua",
      "folke/flash.nvim",
      "telescope-fzf-native.nvim",
      "TwIStOy/project.nvim",
    },
    opts = function()
      ---@type dora.lib
      local lib = require("dora.lib")
      local actions = require("telescope.actions")

      return {
        defaults = {
          selection_caret = "➤ ",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          history = {
            path = vim.fn.stdpath("data")
              .. "/database/telescope_history.sqlite3",
          },
          winblend = lib.vim.current_gui() ~= nil and 20 or 0,
          color_devicons = true,

          mappings = {
            i = {
              ["<C-n>"] = false,
              ["<C-p>"] = false,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Up>"] = actions.cycle_history_prev,
              ["<Down>"] = actions.cycle_history_next,
              ["<Esc>"] = actions.close,
            },
            n = { ["q"] = actions.close },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
            layout_config = {
              height = 0.4,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      local lsp_actions = action.make_options {
        from = "telescope.nvim",
        category = "Telescope",
        condition = function(buffer)
          return #buffer.lsp_servers > 0
        end,
        actions = {
          {
            id = "telescope.lsp-document-symbols",
            title = "Find document symbols",
            callback = function()
              require("telescope.builtin").lsp_document_symbols {}
            end,
            keys = { "<leader>ls", desc = "document-symbols" },
          },
          {
            id = "telescope.lsp-workspace-symbols",
            title = "Find workspace symbols",
            callback = function()
              require("telescope.builtin").lsp_workspace_symbols {}
            end,
            keys = { "<leader>lw", desc = "workspace-symbols" },
          },
        },
      }

      local common_actions = action.make_options {
        from = "telescope.nvim",
        category = "Telescope",
        actions = {
          {
            id = "telescope.all-buffers",
            title = "Find all buffers",
            callback = function()
              require("telescope.builtin").buffers {}
            end,
            keys = { "<F4>", desc = "all-buffers" },
          },
          {
            id = "telescope.find-files",
            callback = function()
              if vim.b._dora_project_cwd ~= nil then
                require("telescope.builtin").find_files {
                  cwd = vim.b._dora_project_cwd,
                  no_ignore = vim.b._dora_project_no_ignore,
                  follow = true,
                }
              else
                require("telescope.builtin").find_files {}
              end
            end,
            title = "Edit project files",
            keys = { "<leader>e", desc = "edit-project-files" },
          },
          {
            id = "telescope.live-grep",
            callback = function()
              if vim.b._dora_project_cwd ~= nil then
                require("telescope.builtin").live_grep {
                  cwd = vim.b._dora_project_cwd,
                  no_ignore = vim.b._dora_project_no_ignore,
                  follow = true,
                }
              else
                require("telescope.builtin").live_grep {}
              end
            end,
            title = "Search for a string in current working directory",
            keys = { "<leader>lg", desc = "live-grep" },
          },
        },
      }

      return {
        unpack(lsp_actions),
        unpack(common_actions),
      }
    end,
  },
}
