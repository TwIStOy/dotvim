return {
  Use {
    "TwIStOy/project.nvim",
    lazy = {
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "PickRecentProject" },
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
          "HomePage.md", -- for my personal obsidian notes 
        },
        exclude_dirs = {
          "~/.cargo/*",
        },
        silent_chdir = false,
        open_callback = function()
          vim.schedule(function()
            if
              vim.fn.argc() == 0
              and vim.o.lines >= 36
              and vim.o.columns >= 80
            then
              require("alpha").redraw()
            end
          end)
        end,
      },
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function(_, opts)
        require("project_nvim").setup(opts)

        vim.api.nvim_create_user_command("PickRecentProject", function()
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
              results = {
                "─",
                "│",
                "─",
                "│",
                "├",
                "┤",
                "╯",
                "╰",
              },
              preview = {
                "─",
                "│",
                "─",
                "│",
                "╭",
                "╮",
                "╯",
                "╰",
              },
            },
          }
        end, {})
      end,
    },
    functions = {
      FuncSpec("Pick recent projects", "PickRecentProject"),
    },
  },
}
