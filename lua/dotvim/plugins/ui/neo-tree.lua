---@type LazyPluginSpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  enabled = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  init = function()
    vim.g.neo_tree_remove_legacy_commands = true
  end,
  keys = {
    {
      "<F2>",
      "<cmd>Neotree action=focus<cr>",
      desc = "open-file-explorer",
    },
    {
      "<leader>ft",
      "<cmd>Neotree action=focus<cr>",
      desc = "open-file-explorer",
    },
  },
  opts = function()
    local icon = require("dotvim.commons.icon")

    return {
      close_if_last_window = true,
      enable_git_status = false,
      enable_diagnostics = true,
      enable_refresh_on_write = false,
      default_component_configs = {
        indent = {
          padding = 0,
          indent_size = 2,
        },
        icon = {
          folder_closed = icon.get("FolderClosed"),
          folder_open = icon.get("FolderOpen"),
          folder_empty = icon.get("FolderEmpty"),
          folder_empty_open = icon.get("FolderEmpty"),
          default = icon.get("DefaultFile"),
        },
        modified = {
          symbol = icon.get("FileModified"),
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = false,
          ["<cr>"] = "open_with_window_picker",
          ["o"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["h"] = "close_node",
          ["l"] = { "toggle_node", nowait = false },
          ["C"] = "close_all_nodes",
          ["z"] = "close_all_nodes",
          ["R"] = "refresh",
          ["a"] = "add",
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["?"] = "show_help",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".git",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
        },
      },
    }
  end,
}
