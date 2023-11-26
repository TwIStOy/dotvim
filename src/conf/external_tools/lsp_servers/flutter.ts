import {
  ActionGroupBuilder,
  LspServer,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "akinsho/flutter-tools.nvim",
  lazy: {
    lazy: true,
    dependencies: [
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    ],
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .from("flutter-tools.nvim")
    .category("Flutter")
    .condition((buffer) => {
      return buffer.filetype === "dart";
    })
    .addOpts({
      id: "flutter-tools.run-project",
      title:
        "Run the current project. This need to be run from within" +
        " a flutter project",
      callback: "FlutterRun",
    })
    .addOpts({
      id: "flutter-tools.select-devices",
      title: "Brings up a list of connected devices to select from",
      callback: "FlutterDevices",
    })
    .addOpts({
      id: "flutter-tools.select-emulators",
      title: "Similar to devices but shows a list of emulators to choose from",
      callback: "FlutterEmulators",
    })
    .addOpts({
      id: "flutter-tools.hot-reload",
      title: "Reload the running project",
      callback: "FlutterReload",
    })
    .addOpts({
      id: "flutter-tools.restart-project",
      title: "Restart the current project",
      callback: "FlutterRestart",
    })
    .addOpts({
      id: "flutter-tools.quit-project",
      title: "Ends a running session",
      callback: "FlutterQuit",
    })
    .addOpts({
      id: "flutter-tools.detach-project",
      title:
        "Ends a running session, but keeps the process running on the device",
      callback: "FlutterDetach",
    })
    .addOpts({
      id: "flutter-tools.toggle-outline",
      title:
        "Toggle the outline window showing the widget tree for the given file",
      callback: "FlutterOutlineToggle",
    })
    .addOpts({
      id: "flutter-tools.open-outline",
      title:
        "Opens an outline window showing the widget tree for the given file",
      callback: "FlutterOutlineOpen",
    })
    .addOpts({
      id: "flutter-tools.start-dev-tools",
      title: "Starts a Dart Dev Tools server",
      callback: "FlutterDevTools",
    })
    .addOpts({
      id: "flutter-tools.active-dev-tools",
      title: "Activates a Dart Dev Tools server",
      callback: "FlutterDevToolsActivate",
    })
    .addOpts({
      id: "flutter-tools.copy-profiler-url",
      title:
        "Copies the profiler url to your system clipboard (+ register). Note that commands FlutterRun and FlutterDevTools must be executed first",
      callback: "FlutterCopyProfilerUrl",
    })
    .addOpts({
      id: "flutter-tools.lsp-restart",
      title:
        "This command restarts the dart language server, and is intended for situations where it begins to work incorrectly",
      callback: "FlutterLspRestart",
    })
    .addOpts({
      id: "flutter-tools.goto-super-class",
      title:
        "Go to super class, method using custom LSP method dart/textDocument/super",
      callback: "FlutterSuper",
    })
    .addOpts({
      id: "flutter-tools.reanalyze",
      title:
        "Forces LSP server reanalyze using custom LSP method dart/reanalyze",
      callback: "FlutterReanalyze",
    })
    .addOpts({
      id: "flutter-tools.rename",
      title:
        "Renames and updates imports if lsp.settings.renameFilesWithClasses == 'always'",
      callback: "FlutterRename",
    })
    .build();
}

const plugin = new Plugin(andActions(spec, generateActions));

export const server = new LspServer({
  name: "flutter",
  plugin,
  exe: false,
  setup: (_, on_attach, capabilities) => {
    luaRequire("flutter-tools").setup({
      ui: {
        border: "solid",
        notification_style: "plugin",
      },
      debugger: {
        enabled: false,
      },
      widget_guides: {
        enabled: false,
      },
      dev_log: {
        enabled: true,
      },
      lsp: {
        color: {
          enabled: true,
        },
        on_attach: on_attach,
        capabilities: capabilities,
        settings: {
          showTodos: false,
          enableSnippets: true,
          completeFunctionCalls: true,
        },
      },
    });
    luaRequire("telescope").load_extension("flutter");
  },
});
