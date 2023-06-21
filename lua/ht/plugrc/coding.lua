return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      local luasnip = require("luasnip")
      local types = require("luasnip.util.types")
      local ft_functions = require("luasnip.extras.filetype_functions")

      luasnip.config.setup {
        enable_autosnippets = true,
        updateevents = "TextChanged,TextChangedI",
        ft_func = ft_functions.from_pos_or_filetype,
      }

      luasnip.add_snippets("all", require("ht.snippets.all")())
      luasnip.add_snippets("cpp", require("ht.snippets.cpp")())
      luasnip.add_snippets("rust", require("ht.snippets.rust")())
      luasnip.add_snippets("lua", require("ht.snippets.lua")())
    end,
    keys = {
      {
        mode = { "i", "s" },
        "<C-e>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
      },
    },
  },

  -- highlight todo comments
  Use {
    "folke/todo-comments.nvim",
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
      local home = os.getenv("HOME")
      vim.g["cph#dir"] = home .. "/Projects/competitive-programming"
      vim.g["cph#lang"] = "cpp"
      vim.g["cph#rust#createjson"] = true
      vim.g["cph#cpp#compile_command"] =
        "g++ solution.cpp -std=c++20 -o cpp.out"

      local FF = require("ht.core.functions")
      FF:add_function_set {
        category = "CPHelper",
        functions = {
          FF.t_cmd("Receive a parsed task from browser", "CphReceive"),
          FF.t_cmd("Test a solutions with all cases", "CphTest"),
          {
            title = "Test a solution with a specified case",
            f = ExecFunc("CphTest"),
          },
          FF.t_cmd(
            "Retest a solution with all cases without recompiling",
            "CphRetest"
          ),
          {
            title = "Retest a solution with a specified case without recompiling",
            f = ExecFunc("CphRetest"),
          },
          {
            title = "Edit/Add a test case",
            f = ExecFunc("CphEdit"),
          },
          {
            title = "Delete a test case",
            f = ExecFunc("CphDelete"),
          },
        },
      }
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
