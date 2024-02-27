local _yazi
local _lazygit

---@type dora.core.plugin.PluginOption[]
return {
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    "osyo-manga/vim-jplus",
    event = "BufReadPost",
    keys = { { "J", "<Plug>(jplus)", mode = { "n", "v" }, noremap = false } },
    gui = "all",
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    init = function() -- code to run before plugin loaded
      vim.g.toggleterm_terminal_mapping = "<C-t>"
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
    opts = {
      open_mapping = "<C-t>",
      hide_numbers = true,
      direction = "float",
      start_in_insert = true,
      shell = vim.o.shell,
      close_on_exit = true,
      float_opts = { border = "rounded" },
    },
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "toggleterm.nvim",
        category = "ToggleTerm",
        actions = {
          {
            id = "toggleterm.toggle",
            title = "Toggle terminal",
            callback = "ToggleTerm",
            keys = { "<C-t>", desc = "toggle-terminal" },
          },
          {
            id = "toggleterm.yazi",
            title = "Open Yazi",
            callback = function()
              if vim.fn.executable("yazi") ~= 1 then
                vim.notify(
                  "Command [yazi] not found!",
                  vim.log.levels.ERROR,
                  { title = "toggleterm.nvim" }
                )
                return
              end
              local root = vim.fn.getcwd()
              if not _yazi then
                _yazi = require("toggleterm.terminal").Terminal:new {
                  cmd = "yazi",
                  dir = root,
                  direction = "float",
                  close_on_exit = true,
                  start_in_insert = true,
                  hidden = true,
                }
              else
                _yazi:change_dir(root)
              end
              _yazi:toggle()
            end,
            keys = { "<leader>ff", desc = "toggle-yazi" },
          },
          {
            id = "toggleterm.lazygit",
            title = "Open lazygit",
            callback = function()
              if vim.fn.executable("lazygit") ~= 1 then
                vim.notify(
                  "Command [lazygit] not found!",
                  vim.log.levels.ERROR,
                  { title = "toggleterm.nvim" }
                )
                return
              end
              local repo_path = require("ht.utils.fs").git_repo_path()
              if repo_path == nil then
                vim.notify(
                  "Not in a git repo!",
                  vim.log.levels.ERROR,
                  { title = "toggleterm.nvim" }
                )
                return
              end
              if not _lazygit then
                _lazygit = require("toggleterm.terminal").Terminal:new {
                  cmd = "lazygit",
                  dir = repo_path,
                  direction = "float",
                  close_on_exit = true,
                  start_in_insert = true,
                  hidden = true,
                }
              else
                _lazygit:change_dir(repo_path)
              end
              _lazygit:toggle()
            end,
            keys = { "<leader>g", desc = "toggle-lazygit" },
          },
        },
      }
    end,
  },
}
