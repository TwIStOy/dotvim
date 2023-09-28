local function flash(prompt_bufnr)
  require("flash").jump {
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
            ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker =
        require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  }
end

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
        -- preview_width = 0.6,
      },

      history = {
        path = vim.fn.stdpath("data") .. "/database/telescope_history.sqlite3",
      },

      winblend = require("ht.core.const").is_gui and 20 or 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
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
          ["<C-s>"] = flash,
        },
        n = { ["q"] = actions.close, ["s"] = flash },
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
    extensions = extensions,
  }

  require("telescope").load_extension("fzf")
  require("telescope").load_extension("notify")
  require("telescope").load_extension("possession")
  require("telescope").load_extension("command_palette")
  require("telescope").load_extension("projects")
  require("telescope").load_extension("obsidian")
end

local telescope_functions = {
  FuncSpec("List open buffers in current neovim instance", function()
    require("telescope.builtin").buffers {}
  end, {
    keys = "<F4>",
    desc = "f-buffers",
  }),
  FuncSpec("List files in current working directory", function()
    local ft = vim.api.nvim_get_option_value("filetype", {
      buf = 0,
    })
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
      FuncSpec("List LSP document symbols in the current buffer", function()
        require("telescope").extensions.aerial.aerial()
      end, {
        keys = "<leader>ls",
        desc = "document-symbols",
      }),
      FuncSpec("List LSP document symbols in the current workspace", function()
        require("telescope.builtin").lsp_workspace_symbols()
      end, {
        keys = "<leader>lw",
        desc = "workspace-symbols",
      }),
    },
  },
  FuncSpec("Search for a string in current working directory", function()
    local ft = vim.api.nvim_get_option_value("filetype", {
      buf = 0,
    })
    if ft == "cpp" then
      local root = require("cpp-toolkit.rooter").get_resolved_root()
      if root ~= nil then
        require("telescope.builtin").live_grep {
          cwd = vim.b.cpp_toolkit_resolved_root.value,
        }
        return
      end
    end
    require("telescope.builtin").live_grep {}
  end, {
    keys = { "<leader>lg", "<D-/>" },
    desc = "live-grep",
  }),
  FuncSpec("Show current git status in current working directory", function()
    if require("ht.utils.fs").in_git_repo() then
      require("telescope.builtin").git_status {}
    else
      vim.notify("Not in a git repo", vim.log.levels.ERROR)
    end
  end, {
    keys = "<leader>vs",
    desc = "git-status",
  }),
  FuncSpec("Show all highlight groups", function()
    require("telescope.builtin").highlights {}
  end),
}

return {
  Use {
    "nvim-telescope/telescope.nvim",
    lazy = {
      cmd = { "Telescope" },
      lazy = true,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "kkharji/sqlite.lua",
        "folke/flash.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          lazy = true,
          build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
        "TwIStOy/project.nvim",
      },
      config = config,
    },
    functions = telescope_functions,
  },
}
