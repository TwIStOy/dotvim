local _lazygit = nil
local _yazi = nil

return {
  Use {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = {
      lazy = true,
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
    },
    functions = {
      FuncSpec("Toggle terminal", "ToggleTerm", {
        keys = "<C-t>",
        desc = "toggle-terminal",
      }),
      FuncSpec("Open Yazi", function()
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
            direction = "float",
            close_on_exit = true,
            start_in_insert = true,
            hidden = true,
          }
        else
          _yazi:change_dir(root)
        end
        _yazi:toggle()
      end, {
        keys = "<leader>ff",
        desc = "toggle-yazi",
      }),
      FuncSpec("Open lazygit", function()
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
      end, {
        keys = "<leader>g",
        desc = "toggle-lazygit",
      }),
    },
  },
}
