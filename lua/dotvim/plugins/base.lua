---@module "dotvim.plugins.base"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "MunifTanjim/nui.nvim" },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
    },
  },
  {
    "willothy/flatten.nvim",
    enabled = not vim.g.vscode,
    lazy = false,
    priority = 1001,
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    enabled = not vim.g.vscode,
    init = function()
      vim.g.toggleterm_terminal_mapping = "<C-t>"
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
    keys = function()
      local open_prog_term = function(prog, get_dir)
        return function()
          local exec = Commons.which(prog)
          if exec == nil then
            vim.notify(
              string.format("Command [%s] not found!", prog),
              vim.log.levels.ERROR,
              { title = "toggleterm.nvim" }
            )
            return
          end
          require("toggleterm.terminal").Terminal
            :new({
              cmd = prog,
              dir = get_dir and get_dir() or vim.fn.getcwd(),
              direction = "float",
              close_on_exit = true,
              float_opts = { border = "none" },
              start_in_insert = true,
              hidden = true,
            })
            :open()
        end
      end
      return {
        {
          "<leader>ff",
          open_prog_term("yazi"),
          desc = "open-yazi",
        },
        {
          "<leader>g",
          open_prog_term("gitui", function()
            return vim.fn.expand("%:p:h")
          end),
          desc = "open-lazygit",
        },
      }
    end,
  },
}
