---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.misc.tools",
  plugins = {
    {
      "skywind3000/asynctasks.vim",
      enabled = true,
      cmd = {
        "AsyncTask",
        "AsyncTaskMacro",
        "AsyncTaskProfile",
        "AsyncTaskEdit",
      },
      init = function()
        vim.g.asyncrun_open = 10
        vim.g.asyncrun_bell = 0
        vim.g.asyncrun_rootmarks = {
          "BLADE_ROOT",
          "JK_ROOT",
          "WORKSPACE",
          ".buckconfig",
          "CMakeLists.txt",
        }
        vim.g.asynctasks_extra_config =
          { "~/.dotfiles/dots/tasks/asynctasks.ini" }
      end,
      dependencies = {
        { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },
      },
    },
    {
      "topaxi/gh-actions.nvim",
      name = "gh-actions.nvim",
      pname = "gh-actions-nvim",
      cmd = { "GhActions" },
      dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
      build = "make",
      opts = {},
    },
    {
      "pwntester/octo.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      cmd = { "Octo" },
      opts = {
        default_remote = { "origin", "upstream" },
      },
    },
    {
      "edkolev/tmuxline.vim",
      cmd = { "Tmuxline" },
    },
  },
}
