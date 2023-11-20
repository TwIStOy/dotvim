import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "skywind3000/asynctasks.vim",
  lazy: {
    cmd: ["AsyncTask", "AsyncTaskMacro", "AsyncTaskProfile", "AsyncTaskEdit"],
    init: () => {
      // quickfix window height
      vim.g.asyncrun_open = 10;
      // disable bell after finished
      vim.g.asyncrun_bell = 0;

      vim.g.asyncrun_rootmarks = [
        "BLADE_ROOT", // for blade(c++)
        "JK_ROOT", // for jk(c++)
        "WORKSPACE", // for bazel(c++)
        ".buckconfig", // for buck(c++)
        "CMakeLists.txt", // for cmake(c++)
      ];

      vim.g.asynctasks_extra_config = ["~/.dotfiles/dots/tasks/asynctasks.ini"];
    },
    dependencies: [
      { [1]: "skywind3000/asyncrun.vim", cmd: ["AsyncRun", "AsyncStop"] },
    ],
  },
    allowInVscode: true,
  extends: {
    commands: [
      {
        name: "Run build-file task",
        description: "Execute the build-file task using asynctasks.vim",
        callback: "AsyncTask file-build",
        menuBar: {
          title: "Run build-file task",
          path: ["Build"],
        },
      },
      {
        name: "Run build-project task",
        description: "Execute the build-project task using asynctasks.vim",
        callback: "AsyncTask project-build",
        menuBar: {
          title: "Run build-project task",
          path: ["Build"],
        },
      },
    ],
  },
};

export default new Plugin(spec);
