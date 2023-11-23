import { predefinedIcon } from "@core/icons";
import { Plugin, PluginOptsBase } from "@core/model";

function jumpToNeoTree() {
  vim.api.nvim_command("Neotree action=focus");
}

const spec: PluginOptsBase = {
  shortUrl: "nvim-neo-tree/neo-tree.nvim",
  lazy: {
    branch: "main",
    dependencies: ["MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons"],
    cmd: ["Neotree"],
    init: () => {
      vim.g.neo_tree_remove_legacy_commands = true;
    },
    keys: [
      {
        [1]: "<F3>",
        [2]: jumpToNeoTree,
        desc: "file-explorer",
      },
      {
        [1]: "<leader>ft",
        [2]: jumpToNeoTree,
        desc: "file-explorer",
      },
    ],
    opts: {
      auto_clean_after_session_restore: true,
      close_if_last_window: true,
      enable_refresh_on_write: false,
      sources: ["filesystem", "buffers", "git_status"],
      source_selector: {
        winbar: true,
        content_layout: "center",
        sources: [
          {
            source: "filesystem",
            display_name: `${predefinedIcon("FolderClosed", 1)}File`,
          },
          {
            source: "buffers",
            display_name: `${predefinedIcon("DefaultFile", 1)}Bufs`,
          },
          {
            source: "git_status",
            display_name: `${predefinedIcon("Git", 1)}Git`,
          },
          {
            source: "diagnostics",
            display_name: `${predefinedIcon("Diagnostic", 1)}Diagnostic`,
          },
        ],
      },
      default_component_configs: {
        indent: { padding: 0 },
        icon: {
          folder_closed: predefinedIcon("FolderClosed"),
          folder_open: predefinedIcon("FolderOpen"),
          folder_empty: predefinedIcon("FolderEmpty"),
          folder_empty_open: predefinedIcon("FolderEmpty"),
          default: predefinedIcon("DefaultFile"),
        },
        modified: { symbol: predefinedIcon("FileModified") },
        git_status: {
          symbols: {
            added: predefinedIcon("GitAdd"),
            deleted: predefinedIcon("GitDelete"),
            modified: predefinedIcon("GitChange"),
            renamed: predefinedIcon("GitRenamed"),
            untracked: predefinedIcon("GitUntracked"),
            ignored: predefinedIcon("GitIgnored"),
            unstaged: predefinedIcon("GitUnstaged"),
            staged: predefinedIcon("GitStaged"),
            conflict: predefinedIcon("GitConflict"),
          },
        },
      },
      commands: {
        parent_or_close: (state: AnyTable) => {
          let node = state.tree.get_node();
          if (
            (node.type == "directory" || node.has_children()) &&
            node.is_expanded()
          ) {
            state.commands.toggle_node(state);
          } else {
            luaRequire("neo-tree.ui.renderer").focus_node(
              state,
              node.get_parent_id()
            );
          }
        },
        child_or_open: (state: AnyTable) => {
          let node = state.tree.get_node();
          if (node.type === "directory" || node.has_children()) {
            if (!node.is_expanded()) {
              state.commands.toggle_node(state);
            } else {
              luaRequire("neo-tree.ui.renderer").focus_node(
                state,
                node.get_child_ids()[1]
              );
            }
          } else {
            state.commands.open(state);
          }
        },
        copy_selector: (state: AnyTable) => {
          let node = state.tree.get_node();
          let filepath = node.get_id();
          let filename = node.name;
          let modify = vim.fn.fnamemodify;

          let vals = {
            ["BASENAME"]: modify(filename, ":r"),
            ["EXTENSION"]: modify(filename, ":e"),
            ["FILENAME"]: filename,
            ["PATH (CWD)"]: modify(filepath, ":."),
            ["PATH (HOME)"]: modify(filepath, ":~"),
            ["PATH"]: filepath,
            ["URI"]: vim.uri_from_fname(filepath),
          };
          let options = vim
            .tbl_keys(vals)
            .filter((val) => vals[val as any as keyof typeof vals] !== "");
          if (options.length === 0) {
            vim.notify("No values to copy", vim.log.levels.WARN);
            return;
          }
          options = options.sort();
          vim.ui.select(
            options,
            {
              prompt: "Choose to copy to clipboard:",
              format_item: (item: any) => {
                return `${item}: ${vals[item as any as keyof typeof vals]}}`;
              },
            },
            (choice: keyof typeof vals) => {
              let result = vals[choice];
              if (result) {
                vim.notify(`Copied: \`${result}\``);
                vim.fn.setreg("+", result);
              }
            }
          );
        },
        find_in_dir: (state: AnyTable) => {
          let node = state.tree.get_node();
          let path = node.get_id();
          let cwd;
          if (node.type === "directory") {
            cwd = path;
          } else {
            cwd = vim.fn.fnamemodify(path, ":h");
          }
          luaRequire("telescope.builtin").find_files({
            cwd,
          });
        },
      },
      window: {
        width: 40,
        mappings: {
          ["<space>"]: false,
          ["[b"]: "prev_source",
          ["]b"]: "next_source",
          ["<cr>"]: "open_with_window_picker",
          F: "find_in_dir",
          Y: "copy_selector",
          h: "parent_or_close",
          l: "child_or_open",
          o: "open",
        },
        fuzzy_finder_mappings: {
          ["<C-j>"]: "move_cursor_down",
          ["<C-k>"]: "move_cursor_up",
        },
      },
      filesystem: {
        follow_current_file: { enabled: true },
        hijack_netrw_behavior: "open_current",
        use_libuv_file_watcher: false,
        filtered_items: {
          hide_gitignored: false,
          hide_dotfiles: false,
          hide_by_name: ["node_modules"],
          never_show: [".DS_Store", "thumbs.db"],
        },
      },
      event_handlers: [
        {
          event: "neo_tree_buffer_enter",
          handler: () => {
            vim.opt_local.signcolumn = "auto";
          },
        },
      ],
    },
  },
};

export const plugin = new Plugin(spec);
