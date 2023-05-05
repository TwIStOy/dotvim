return {
  -- snippet engine
  Use {
    "TwIStOy/ultisnips",
    functions = {
      FuncSpec("Refresh snippets", "call UltiSnips#RefreshSnippets()"),
    },
    lazy = {
      event = "InsertEnter",
      config = function()
        vim.cmd([[py3 from snippet_tools.cpp import register_postfix_snippets]])
        vim.cmd([[py3 register_postfix_snippets()]])
      end,
    },
  },

  -- highlight todo comments
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
      highlight = { keyword = "bg", pattern = [[.*<(KEYWORDS)\([^)]*\):]] },
      search = { pattern = [[.*<(KEYWORDS)\([^)]*\):]] },
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
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "open-todo-trouble" },
      {
        "<leader>xT",
        "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
        desc = "open-TFF-trouble",
      },
      { "<leader>lt", "<cmd>TodoTelescope<cr>", desc = "list-todos" },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)

      require("ht.core.functions"):add_function_set {
        category = "TodoComments",
        functions = {
          {
            title = "Open todo-comments in telescope",
            f = function()
              vim.cmd("TodoTelescope")
            end,
          },
          {
            title = "Open all kind of todo-comments in trouble",
            f = function()
              vim.cmd("TodoTrouble keywords=TODO,FIX,FIXME")
            end,
          },
          {
            title = "Open todo-comments in trouble",
            f = function()
              vim.cmd("TodoTrouble")
            end,
          },
        },
      }
    end,
  },

  -- asynctask
  {
    "skywind3000/asynctasks.vim",
    cmd = { "AsyncTask", "AsyncTaskMacro", "AsyncTaskProfile", "AsyncTaskEdit" },
    -- quickfix window height
    init = function()
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

      require("ht.core.functions"):add_function_set {
        category = "AsyncTasks",
        functions = {
          {
            title = "Run build-file task",
            f = function()
              vim.cmd("AsyncTask file-build")
            end,
          },
          {
            title = "Run build-project task",
            f = function()
              vim.cmd("AsyncTask project-build")
            end,
          },
        },
      }
    end,
    keys = {
      { "<leader>bf", "<cmd>AsyncTask file-build<CR>", desc = "build-file" },
      {
        "<leader>bp",
        "<cmd>AsyncTask project-build<CR>",
        desc = "build-project",
      },
    },
  },
  { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },

  -- for cp programming
  {
    "p00f/cphelper.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "CphReceive", "CphTest", "CphRetest", "CphEdit", "CphDelete" },
    keys = { { "<F9>", "<cmd>CphTest<CR>", desc = "Run cp test" } },
    init = function()
      vim.g["cph#dir"] = "/Users/hawtian/Projects/competitive-programming"
      vim.g["cph#lang"] = "cpp"
      vim.g["cph#rust#createjson"] = true
      vim.g["cph#cpp#compile_command"] =
        "g++ solution.cpp -std=c++20 -o cpp.out"
    end,
  },

  -- templates
  {
    "aperezdc/vim-template",
    cmd = { "Template", "TemplateHere" },
    enabled = function()
      if vim.g["neovide"] or vim.g["fvim_loaded"] then
        return false
      end
      return true
    end,
    init = function()
      vim.g.templates_directory = {
        os.getenv("HOME") .. [[/.dotvim/vim-templates]],
      }
      vim.g.templates_no_autocmd = 0
      vim.g.templates_debug = 0
      vim.g.templates_no_builtin_templates = 1
    end,
  },

  -- toggle code comments
  {
    "tomtom/tcomment_vim",
    event = "BufReadPost",
    init = function()
      vim.g.tcomment_maps = 0
    end,
    keys = {
      { "gcc", "<cmd>TComment<CR>", desc = "toggle-comment" },
      { "gcc", ":TCommentBlock<CR>", mode = "v", desc = "toggle-comment" },
    },
  },

  -- gen document
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    lazy = true,
    opts = { input_after_comment = false },
    config = true,
  },
}
