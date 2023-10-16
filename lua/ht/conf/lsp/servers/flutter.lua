local RightClick = require("ht.core.right-click")
local CoreLspServer = require("ht.core.lsp.server")

local function t_cmd(s, cmd, keys)
  return {
    s,
    callback = function()
      vim.cmd(cmd)
    end,
    keys = keys,
  }
end

local function f_cmd(title, cmd)
  return {
    title = title,
    f = function()
      vim.cmd(cmd)
    end,
  }
end

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "flutter"

opts.mason = false

opts.setup = function(on_buffer_attach, capabilities)
  require("flutter-tools").setup {
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
    lsp = {
      color = {
        enabled = true,
      },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
      settings = {
        showTodos = false,
        enableSnippets = true,
        completeFunctionCalls = true,
      },
    },
  }
  require("telescope").load_extension("flutter")
end

opts.right_click = {
  {
    index = RightClick.indexes.flutter,
    enabled = {
      filetype = {
        "dart",
      },
    },
    items = {
      t_cmd("Flutter: Run", "FlutterRun"),
      t_cmd("Flutter: Hot Restart", "FlutterRestart", { "R" }),
      {
        "Flutter More",
        keys = { "F" },
        children = {
          t_cmd("Hot Reload", "FlutterReload"),
          t_cmd("Toggle Outline", "FlutterOutlineToggle"),
          t_cmd("Open Outline", "FlutterOutlineOpen"),
          t_cmd("Go to super class", "FlutterSuper"),
        },
      },
    },
  },
}

opts.function_sets = {
  {
    category = "Flutter",
    ---@param buffer VimBuffer
    filter = function(buffer)
      for _, server in ipairs(buffer.lsp_servers) do
        if server.name == "dartls" then
          return true
        end
      end
      return false
    end,
    functions = {
      f_cmd(
        "Run the current project. This needs to be run from within a flutter project",
        "FlutterRun"
      ),
      f_cmd(
        "Brings up a list of connected devices to select from",
        "FlutterDevices"
      ),
      f_cmd(
        "Similar to devices but shows a list of emulators to choose from",
        "FlutterEmulators"
      ),
      f_cmd("Reload the running project", "FlutterReload"),
      f_cmd("Restart the current project", "FlutterRestart"),
      f_cmd("Ends a running session", "FlutterQuit"),
      f_cmd(
        "Ends a running session locally but keeps the process running on the device",
        "FlutterDetach"
      ),
      f_cmd(
        "Toggle the outline window showing the widget tree for the given file",
        "FlutterOutlineToggle"
      ),
      f_cmd(
        "Opens an outline window showing the widget tree for the given file",
        "FlutterOutlineOpen"
      ),
      f_cmd("Starts a Dart Dev Tools server", "FlutterDevTools"),
      f_cmd("Activates a Dart Dev Tools server", "FlutterDevToolsActivate"),
      f_cmd(
        "Copies the profiler url to your system clipboard (+ register). Note that commands FlutterRun and FlutterDevTools must be executed first",
        "FlutterCopyProfilerUrl"
      ),
      f_cmd(
        "This command restarts the dart language server, and is intended for situations where it begins to work incorrectly",
        "FlutterLspRestart"
      ),
      f_cmd(
        "Go to super class, method using custom LSP method dart/textDocument/super",
        "FlutterSuper"
      ),
      f_cmd(
        "Forces LSP server reanalyze using custom LSP method dart/reanalyze",
        "FlutterReanalyze"
      ),
      f_cmd(
        [[Renames and updates imports if lsp.settings.renameFilesWithClasses == "always"]],
        "FlutterRename"
      ),
    },
  },
}

return CoreLspServer.new(opts)
