import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

function generateActions() {
  return ActionGroupBuilder.start()
    .category("AsyncTask")
    .from("asynctasks.vim")
    .addOpts({
      id: "asynctasks.run",
      title: "Run build-file task",
      callback: "AsyncTask file-build",
      description: "Execute the build-file task using asynctasks.vim",
    })
    .addOpts({
      id: "asynctasks.run",
      title: "Run build-project task",
      callback: "AsyncTask project-build",
      description: "Execute the build-project task using asynctasks.vim",
    })
    .build();
}

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
};

export const plugin = new Plugin(andActions(spec, generateActions));
