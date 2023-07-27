local _lazygit = nil

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
        highlights = {
          Normal = {
            link = "Normal",
          },
          NormalFloat = {
            link = "NormalFloat",
          },
          FloatBorder = {
            link = "FloatBorder",
          },
        },
      },
    },
    functions = {
      FuncSpec("Toggle terminal", "ToggleTerm", {
        keys = "<C-t>",
        desc = "toggle-terminal",
      }),
      FuncSpec("Open lazygit", function()
        if vim.fn.executable("lazygit") == 1 then
          if not _lazygit then
            _lazygit = require("toggleterm.terminal").Terminal:new {
              cmd = "lazygit",
              direction = "float",
              close_on_exit = true,
              start_in_insert = true,
              hidden = true,
            }
          end
          _lazygit:toggle()
        else
          vim.notify(
            "Command [lazygit] not found!",
            vim.log.levels.ERROR,
            { title = "toggleterm.nvim" }
          )
        end
      end, {
        keys = "<leader>g",
        desc = "toggle-lazygit",
      }),
    },
  },
}
