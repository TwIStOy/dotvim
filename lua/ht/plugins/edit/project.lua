return {
  Use {
    "ahmedkhalf/project.nvim",
    lazy = {
      event = "VeryLazy",
      opts = {
        detection_methods = { "pattern" },
        patterns = {
          "BLADE_ROOT",
          "blast.json",
          ".git",
          "_darcs",
          ".hg",
          ".bzr",
          ".svn",
          "Makefile",
        },
        exclude_dirs = {
          "~/.cargo/*",
        },
        silent_chdir = false,
      },
      config = function(_, opts)
        require("project_nvim").setup(opts)
      end,
    },
    functions = {
      FuncSpec("Pick recent projects", function()
        require("telescope").extensions.projects.projects {
          layout_strategy = "center",
          sorting_strategy = "ascending",
          layout_config = {
            anchor = "N",
            width = 0.5,
            prompt_position = "top",
            height = 0.5,
          },
          border = true,
          results_title = false,
          -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
          borderchars = {
            prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          },
        }
      end),
    },
  },
}
