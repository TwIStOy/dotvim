return {
  Use {
    "akinsho/flutter-tools.nvim",
    lazy = {
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
        "nvim-telescope/telescope.nvim",
      },
      config = true,
    },
    category = "Flutter",
    functions = {
      FuncSpec(
        "Run the current project. This needs to be run from within a flutter project",
        "FlutterRun"
      ),
      FuncSpec(
        "Brings up a list of connected devices to select from",
        "FlutterDevices"
      ),
      FuncSpec(
        "Similar to devices but shows a list of emulators to choose from",
        "FlutterEmulators"
      ),
      FuncSpec("Reload the running project", "FlutterReload"),
      FuncSpec("Restart the current project", "FlutterRestart"),
      FuncSpec("Ends a running session", "FlutterQuit"),
      FuncSpec(
        "Ends a running session locally but keeps the process running on the device",
        "FlutterDetach"
      ),
      FuncSpec(
        "Toggle the outline window showing the widget tree for the given file",
        "FlutterOutlineToggle"
      ),
      FuncSpec(
        "Opens an outline window showing the widget tree for the given file",
        "FlutterOutlineOpen"
      ),
      FuncSpec("Starts a Dart Dev Tools server", "FlutterDevTools"),
      FuncSpec("Activates a Dart Dev Tools server", "FlutterDevToolsActivate"),
      FuncSpec(
        "Copies the profiler url to your system clipboard (+ register). Note that commands FlutterRun and FlutterDevTools must be executed first",
        "FlutterCopyProfilerUrl"
      ),
      FuncSpec(
        "This command restarts the dart language server, and is intended for situations where it begins to work incorrectly",
        "FlutterLspRestart"
      ),
      FuncSpec(
        "Go to super class, method using custom LSP method dart/textDocument/super",
        "FlutterSuper"
      ),
      FuncSpec(
        "Forces LSP server reanalyze using custom LSP method dart/reanalyze",
        "FlutterReanalyze"
      ),
      FuncSpec(
        [[Renames and updates imports if lsp.settings.renameFilesWithClasses == "always"]],
        "FlutterRename"
      ),
    },
  },
}
