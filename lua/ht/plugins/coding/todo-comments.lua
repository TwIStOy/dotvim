return {
  -- highlight todo comments
  Use {
    "TwIStOy/todo-comments.nvim",
    category = "TodoComments",
    functions = {
      FuncSpec("Open todos in trouble", "TodoTrouble", {
        keys = "<leader>xt",
        desc = "open-todo-trouble",
      }),
      FuncSpec(
        "Open todos,fix,fixme in trouble",
        "TodoTrouble keywords=TODO,FIX,FIXME",
        {
          keys = "<leader>xT",
          desc = "open-TFF-trouble",
        }
      ),
      FuncSpec("List all todos using telescope", "TodoTelescope", {
        keys = "<leader>lt",
        desc = "list-todos",
      }),
    },
    lazy = {
      event = "BufReadPost",
      cmd = {
        "TodoTrouble",
        "TodoTelescope",
      },
      opts = {
        highlight = { keyword = "wide_bg", pattern = [[(KEYWORDS)\([^)]*\):]] },
        search = { pattern = [[(KEYWORDS)\([^)]*\):]] },
        keywords = {
          HACK = { alt = { "UNSAFE" } },
        },
      },
      keys = {
        {
          "]t",
          function()
            require("todo-comments").jump_next()
          end,
          desc = "goto-next-todo",
        },
        {
          "[t",
          function()
            require("todo-comments").jump_prev()
          end,
          desc = "goto-prev-todo",
        },
      },
      config = true,
    },
  },
}
