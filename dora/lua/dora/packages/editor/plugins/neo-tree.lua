---@type dora.core.plugin.PluginOption
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "main",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "Neotree" },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = true
  end,
  keys = {
    {
      "<F3>",
      function()
        vim.api.nvim_command("Neotree action=focus")
      end,
      desc = "file-explorer",
    },
    {
      "<leader>ft",
      function()
        vim.api.nvim_command("Neotree action=focus")
      end,
      desc = "file-explorer",
    },
  },
  opts = function()
    ---@type dora.config
    local config = require("dora.config")
    local predefined_icon = config.icon.predefined_icon

    return {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      enable_refresh_on_write = false,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          {
            source = "filesystem",
            display_name = predefined_icon("FolderClosed", 1) .. "File",
          },
          {
            source = "buffers",
            display_name = predefined_icon("DefaultFile", 1) .. "Bufs",
          },
          {
            source = "git_status",
            display_name = predefined_icon("Git", 1) .. "Git",
          },
          {
            source = "diagnostics",
            display_name = predefined_icon("Diagnostic", 1) .. "Diagnostic",
          },
        },
      },
      default_component_configs = {
        indent = { padding = 0 },
        icon = {
          folder_closed = predefined_icon("FolderClosed"),
          folder_open = predefined_icon("FolderOpen"),
          folder_empty = predefined_icon("FolderEmpty"),
          folder_empty_open = predefined_icon("FolderEmpty"),
          default = predefined_icon("DefaultFile"),
        },
        modified = { symbol = predefined_icon("FileModified") },
        git_status = {
          symbols = {
            added = predefined_icon("GitAdd"),
            deleted = predefined_icon("GitDelete"),
            modified = predefined_icon("GitChange"),
            renamed = predefined_icon("GitRenamed"),
            untracked = predefined_icon("GitUntracked"),
            ignored = predefined_icon("GitIgnored"),
            unstaged = predefined_icon("GitUnstaged"),
            staged = predefined_icon("GitStaged"),
            conflict = predefined_icon("GitConflict"),
          },
        },
      },
      commands = {
        parent_or_close = function(state)
          local node = state.tree.get_node()
          if
            (node.type == "directory" or node.has_children())
            and node.is_expanded()
          then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(
              state,
              node.get_parent_id()
            )
          end
        end,
        child_or_open = function(state)
          local node = state.tree.get_node()
          if node.type == "directory" or node.has_children() then
            if not node.is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(
                state,
                node.get_child_ids()[1]
              )
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree.get_node()
          local filepath = node.get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify
          local vals = {
            BASENAME = modify(filename, ":r"),
            EXTENSION = modify(filename, ":e"),
            FILENAME = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            PATH = filepath,
            URI = vim.uri_from_fname(filepath),
          }
          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))
          if #options == 0 then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return tostring(item) .. ": " .. tostring(vals[item]) .. "}"
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify("Copied: " .. tostring(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
        find_in_dir = function(state)
          local node = state.tree.get_node()
          local path = node.get_id()
          local cwd
          if node.type == "directory" then
            cwd = path
          else
            cwd = vim.fn.fnamemodify(path, ":h")
          end
          require("telescope.builtin").find_files { cwd = cwd }
        end,
      },
      window = {
        width = 40,
        mappings = {
          ["<space>"] = false,
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          ["<cr>"] = "open_with_window_picker",
          F = "find_in_dir",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
          o = "open",
        },
        fuzzy_finder_mappings = {
          ["<C-j>"] = "move_cursor_down",
          ["<C-k>"] = "move_cursor_up",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = false,
        filtered_items = {
          hide_gitignored = true,
          hide_dotfiles = false,
          hide_by_name = { "node_modules" },
          never_show = { ".DS_Store", "thumbs.db" },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "auto"
          end,
        },
      },
    }
  end,
}
