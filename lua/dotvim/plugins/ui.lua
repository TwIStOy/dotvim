---@type LazyPluginSpec[]
return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- Import components module
      local components = require("dotvim.configs.lualine_components")
      local utils = require("dotvim.configs.lualine_components.utils")
      local icon = require("dotvim.commons.icon")

      local lualine = require("lualine")

      lualine.setup {
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "snacks_dashboard", "dashboard", "alpha", "starter" },
          },
          always_divide_middle = true,
          padding = 0,
        },
        sections = {
          lualine_a = {
            components.get("space"),
            components.get("mode"),
          },
          lualine_b = {
            components.get("space"),
          },
          lualine_c = {
            components.get("cwd"),
            components.get("file"),
            components.get("space"),
            components.get("branch"),
            components.get("diff"),
            components.get("space"),
            components.get("macro"),
            components.get("search_count"),
            components.get("c_preproc"),
          },
          lualine_x = {
            components.get("lsp_progress"),
            components.get("space"),
            components.get("diagnostics"),
          },
          lualine_y = {
            {
              components.get("copilot"),
              separator = { left = "", right = "" },
            },
            components.get("space"),
          },
          lualine_z = {
            components.get("lsp_servers"),
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { components.get("file") },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {
          {
            filetypes = { "neo-tree" },
            sections = {
              lualine_a = {
                {
                  function()
                    return require("dotvim.commons.icon").get("FolderClosed", 1)
                      .. "Neo-tree"
                  end,
                  separator = { left = "", right = "" },
                },
              },
              lualine_b = {
                components.get("space"),
              },
              lualine_c = {
                components.get("cwd"),
              },
            },
          },
          {
            filetypes = { "toggleterm" },
            sections = {
              lualine_a = {
                {
                  function()
                    return icon.get("Terminal", 1)
                      .. "ToggleTerm #"
                      .. vim.b.toggle_number
                  end,
                  separator = { left = "", right = "" },
                },
              },
              lualine_b = {
                components.get("space"),
              },
              lualine_c = {
                components.get("cwd"),
                {
                  function()
                    return vim.fn.getcwd()
                  end,
                  color = {
                    bg = utils.resolve_bg("CursorLine"),
                    fg = utils.resolve_fg("Normal"),
                  },
                  separator = { left = "", right = "" },
                  padding = { left = 1 },
                },
              },
            },
          },
          {
            filetypes = { "lazy" },
            sections = {
              lualine_a = {
                {
                  function()
                    return icon.get("Package", 1) .. "lazy"
                  end,
                  separator = { left = "", right = "" },
                },
              },
              lualine_b = {
                {
                  function()
                    local ok, lazy = pcall(require, "lazy")
                    if not ok then
                      return ""
                    end
                    return "loaded: "
                      .. lazy.stats().loaded
                      .. "/"
                      .. lazy.stats().count
                  end,
                  padding = { left = 1 },
                  separator = { left = "", right = "" },
                },
              },
              lualine_c = {
                {
                  function()
                    local ok, lazy_status = pcall(require, "lazy.status")
                    if not ok then
                      return ""
                    end
                    return lazy_status.updates()
                  end,
                  cond = function()
                    local ok, lazy_status = pcall(require, "lazy.status")
                    if not ok then
                      return false
                    end
                    return lazy_status.has_updates()
                  end,
                  separator = { left = "", right = "" },
                },
              },
            },
          },
        },
      }
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    opts = {
      hint = "floating-big-letter",
    },
    config = function(_, opts)
      require("window-picker").setup(opts)
    end,
  },
  {
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
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      stages = "static",
      fps = 60,
      max_height = function()
        return math.floor(
          vim.api.nvim_get_option_value("lines", { scope = "global" }) * 0.75
        )
      end,
      max_width = function()
        return math.floor(
          vim.api.nvim_get_option_value("columns", { scope = "global" }) * 0.75
        )
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      local notifs = {}
      local function temp(...)
        table.insert(notifs, vim.F.pack_len(...))
      end

      local orig = vim.notify
      vim.notify = temp

      local timer = vim.uv.new_timer()
      local check = vim.uv.new_check()

      local replay = function()
        timer:stop()
        check:stop()
        vim.schedule(function()
          if vim.notify == temp then
            -- try to load nvim-notify
            local succ, notify = pcall(require, "notify")
            if succ and notify ~= nil then
              vim.notify = notify
            else
              vim.notify = orig -- put back the original notify if needed
            end
          end
          vim.schedule(function()
            for _, notif in ipairs(notifs) do
              vim.notify(vim.F.unpack_len(notif))
            end
          end)
        end)
      end

      -- wait till vim.notify has been replaced
      check:start(function()
        if vim.notify ~= temp then
          replay()
        end
      end)
      -- or if it took more than 500ms, then something went wrong
      timer:start(500, 0, replay)
    end,
    config = function(_, opts)
      vim.defer_fn(function()
        require("notify").setup(opts)
      end, 30)
    end,
    keys = {
      {
        "<leader>nn",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "dismiss-all-notifications",
        mode = { "n", "v" },
      },
    },
  },
}
