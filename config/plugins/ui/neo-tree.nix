_: {
  globals.neo_tree_remove_legacy_commands = true;

  plugins.neo-tree = {
    enable = true;

    lazyLoad.settings = {
      cmd = "Neotree";
      keys = [
        {
          __unkeyed-1 = "<F2>";
          __unkeyed-2 = "<cmd>Neotree action=focus<cr>";
          desc = "open-file-explorer";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>ft";
          __unkeyed-2 = "<cmd>Neotree action=focus<cr>";
          desc = "open-file-explorer";
          mode = "n";
        }
      ];
    };

    settings = {
      close_if_last_window = true;
      enable_git_status = false;
      enable_diagnostics = true;
      enable_refresh_on_write = false;

      default_component_configs = {
        indent = {
          padding = 0;
          indent_size = 2;
        };
        icon = {
          folder_closed = "";
          folder_open = "";
          folder_empty = "";
          folder_empty_open = "";
          default = "";
        };
        modified = {
          symbol = "";
        };
      };

      window = {
        width = 30;
        mappings = {
          "<space>" = false;
          "<cr>" = "open_with_window_picker";
          "o" = "open";
          "S" = "open_split";
          "s" = "open_vsplit";
          "t" = "open_tabnew";
          "h" = "close_node";
          "l" = {
            command = "toggle_node";
            nowait = false;
          };
          "C" = "close_all_nodes";
          "z" = "close_all_nodes";
          "R" = "refresh";
          "a" = "add";
          "A" = "add_directory";
          "d" = "delete";
          "r" = "rename";
          "y" = "copy_to_clipboard";
          "x" = "cut_to_clipboard";
          "p" = "paste_from_clipboard";
          "c" = "copy";
          "m" = "move";
          "q" = "close_window";
          "?" = "show_help";
        };
      };

      filesystem = {
        follow_current_file = {
          enabled = true;
        };
        hijack_netrw_behavior = "open_current";
        use_libuv_file_watcher = true;
        filtered_items = {
          hide_dotfiles = false;
          hide_gitignored = false;
          hide_by_name = [
            "node_modules"
            ".git"
          ];
          never_show = [
            ".DS_Store"
            "thumbs.db"
          ];
        };
      };

      buffers = {
        follow_current_file = {
          enabled = true;
        };
      };
    };
  };
}
