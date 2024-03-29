---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.dart",
  deps = {
    "dora.packages.coding",
    "dora.packages.lsp",
    "dora.packages.treesitter",
    "dora.packages.ui",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "dart" })
        end
      end,
    },
    {
      "akinsho/flutter-tools.nvim",
      dependencies = {
        "plenary.nvim",
        "dressing.nvim",
        "telescope.nvim",
      },
      lazy = true,
      opts = {},
      actions = function()
        ---@type dora.core.action
        local action = require("dora.core.action")

        return action.make_options {
          from = "flutter-tools.nvim",
          category = "Flutter",
          condition = function(buffer)
            return buffer.filetype == "dart"
          end,
          actions = {
            {
              id = "flutter-tools.run-project",
              title = "Run the current project. "
                .. "This need to be run from within a flutter project",
              callback = "FlutterRun",
            },
            {
              id = "flutter-tools.select-devices",
              title = "Brings up a list of connected devices to select from",
              callback = "FlutterDevices",
            },
            {
              id = "flutter-tools.select-emulators",
              title = "Similar to devices but shows a list of "
                .. "emulators to choose from",
              callback = "FlutterEmulators",
            },
            {
              id = "flutter-tools.hot-reload",
              title = "Reload the running project",
              callback = "FlutterReload",
            },
            {
              id = "flutter-tools.restart-project",
              title = "Restart the current project",
              callback = "FlutterRestart",
            },
            {
              id = "flutter-tools.quit-project",
              title = "Ends a running session",
              callback = "FlutterQuit",
            },
            {
              id = "flutter-tools.detach-project",
              title = "Ends a running session, but keeps the process"
                .. " running on the device",
              callback = "FlutterDetach",
            },
            {
              id = "flutter-tools.toggle-outline",
              title = "Toggle the outline window showing the widget tree for "
                .. "the given file",
              callback = "FlutterOutlineToggle",
            },
            {
              id = "flutter-tools.open-outline",
              title = "Opens an outline window showing the widget tree for the"
                .. " given file",
              callback = "FlutterOutlineOpen",
            },
            {
              id = "flutter-tools.start-dev-tools",
              title = "Starts a Dart Dev Tools server",
              callback = "FlutterDevTools",
            },
            {
              id = "flutter-tools.active-dev-tools",
              title = "Activates a Dart Dev Tools server",
              callback = "FlutterDevToolsActivate",
            },
            {
              id = "flutter-tools.copy-profiler-url",
              title = "Copies the profiler url to your system clipboard "
                .. "(+ register). Note that commands FlutterRun and "
                .. "FlutterDevTools must be executed first",
              callback = "FlutterCopyProfilerUrl",
            },
            {
              id = "flutter-tools.lsp-restart",
              title = "This command restarts the dart language server, and "
                .. "is intended for situations where it begins to work"
                .. " incorrectly",
              callback = "FlutterLspRestart",
            },
            {
              id = "flutter-tools.goto-super-class",
              title = "Go to super class, method using custom LSP method "
                .. "dart/textDocument/super",
              callback = "FlutterSuper",
            },
            {
              id = "flutter-tools.reanalyze",
              title = "Forces LSP server reanalyze using custom LSP method "
                .. "dart/reanalyze",
              callback = "FlutterReanalyze",
            },
            {
              id = "flutter-tools.rename",
              title = "Renames and updates imports "
                .. "if lsp.settings.renameFilesWithClasses == 'always'",
              callback = "FlutterRename",
            },
          },
        }
      end,
      config = function() end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            dart = {
              ["flutter-tools"] = {
                fvm = true,
                ui = {
                  border = "solid",
                  notification_style = "plugin",
                },
                debugger = {
                  enabled = false,
                },
                widget_guides = {
                  enabled = false,
                },
                dev_log = {
                  enabled = true,
                },
              },
              color = {
                enabled = true,
              },
              settings = {
                showTodos = false,
                enableSnippets = true,
                completeFunctionCalls = true,
              },
            },
          },
          setup = {
            dart = function(_, server_opts)
              ---@type dora.lib
              local lib = require("dora.lib")

              local lsp_opts =
                lib.tbl.filter_out_keys(server_opts, { "flutter-tools" })
              local flutter_tools_opts = server_opts["flutter-tools"] or {}
              flutter_tools_opts.lsp = lsp_opts
              require("flutter-tools").setup(flutter_tools_opts)
              require("telescope").load_extension("flutter")
            end,
          },
        },
      },
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          dart = { "dart_format" },
        },
      },
    },
  },
}
