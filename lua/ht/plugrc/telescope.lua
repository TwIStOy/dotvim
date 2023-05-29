local function config()
  local actions = require("telescope.actions")
  local extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  }

  if vim.fn.has("maxunix") then
    extensions.dash = {}
  end

  require("telescope").setup {
    defaults = {
      selection_caret = "➤ ",

      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_config = {
        preview_width = 0.6,
      },

      history = { path = "~/.local/share/nvim/telescope_history.sqlite3" },

      winblend = 0,
      border = {},
      -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      -- borderchars = { "█", " ", " ", "█", "█", " ", " ", " " },
      borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      color_devicons = true,

      mappings = {
        i = {
          ["<C-n>"] = false,
          ["<C-p>"] = false,

          ["<C-u>"] = actions.preview_scrolling_down,
          ["<C-d>"] = actions.preview_scrolling_up,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Up>"] = actions.cycle_history_prev,
          ["<Down>"] = actions.cycle_history_next,
          ["<Esc>"] = actions.close,
        },
        n = { ["q"] = actions.close },
      },
    },
    pickers = { find_files = {} },
    extensions = extensions,
  }

  require("telescope").load_extension("fzf")
  require("telescope").load_extension("notify")
  require("telescope").load_extension("possession")
  require("telescope").load_extension("command_palette")
end

return {
  Use {
    "nvim-telescope/telescope.nvim",
    lazy = {
      cmd = { "Telescope" },
      lazy = true,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "kkharji/sqlite.lua",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          lazy = true,
          build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
      },
      config = config,
    },
    functions = {
      FuncSpec("List open buffers in current neovim instance", function()
        require("telescope.builtin").buffers {}
      end, {
        keys = "<F4>",
        desc = "f-buffers",
      }),
      FuncSpec("List files in current working directory", function()
        local ft = vim.bo.filetype
        if ft == "cpp" then
          local root = require("cpp-toolkit.rooter").get_resolved_root()
          if root ~= nil then
            require("telescope.builtin").find_files {
              cwd = vim.b.cpp_toolkit_resolved_root.value,
              no_ignore = true,
              follow = true,
            }
            return
          end
        end
        require("telescope.builtin").find_files {}
      end, {
        keys = "<leader>e",
        desc = "edit-project-file",
      }),
      {
        filter = {
          ---@param buffer VimBuffer
          filter = function(buffer)
            return #buffer.lsp_servers > 0
          end,
        },
        values = {
          FuncSpec(
            "List LSP document symbols in the current buffer",
            function()
              require("telescope.builtin").lsp_document_symbols()
            end,
            {
              keys = "<leader>ls",
              desc = "document-symbols",
            }
          ),
          FuncSpec(
            "List LSP document symbols in the current workspace",
            function()
              require("telescope.builtin").lsp_workspace_symbols()
            end,
            {
              keys = "<leader>lw",
              desc = "workspace-symbols",
            }
          ),
        },
      },
      FuncSpec("Search for a string in current working directory", function()
        if vim.b._dotvim_resolved_project_root ~= nil then
          require("telescope.builtin").live_grep {
            cwd = vim.b._dotvim_resolved_project_root,
          }
        else
          require("telescope.builtin").live_grep {}
        end
      end, {
        keys = "<leader>lg",
        desc = "live-grep",
      }),
    },
  },
}
