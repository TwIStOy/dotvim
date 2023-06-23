return {
  -- asynctask
  Use {
    "skywind3000/asynctasks.vim",
    lazy = {
      cmd = {
        "AsyncTask",
        "AsyncTaskMacro",
        "AsyncTaskProfile",
        "AsyncTaskEdit",
      },
      dependencies = {
        { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },
      },
      init = function()
        -- quickfix window height
        vim.g.asyncrun_open = 10
        -- disable bell after finished
        vim.g.asyncrun_bell = 0

        vim.g.asyncrun_rootmarks = {
          "BLADE_ROOT", -- for blade(c++)
          "JK_ROOT", -- for jk(c++)
          "WORKSPACE", -- for bazel(c++)
          ".buckconfig", -- for buck(c++)
          "CMakeLists.txt", -- for cmake(c++)
        }

        vim.g.asynctasks_extra_config =
          { "~/.dotfiles/dots/tasks/asynctasks.ini" }
      end,
    },
    functions = {
      FuncSpec("Run build-file task", "AsyncTask file-build", {
        keys = "<leader>bf",
        desc = "build-file",
      }),
      FuncSpec("Run build-project task", "AsyncTask project-build", {
        keys = "<leader>bp",
        desc = "build-project",
      }),
    },
  },
}
