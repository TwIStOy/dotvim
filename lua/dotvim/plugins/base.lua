local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "MunifTanjim/nui.nvim" },
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
      insert_mappings = false,
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
        { "<C-t>", nil, desc = "open-term" },
        {
          "<leader>ff",
          open_prog_term("yazi"),
          desc = "open-yazi",
        },
        {
          "<leader>g",
          open_prog_term("lazygit", function()
            return vim.fn.expand("%:p:h")
          end),
          desc = "open-lazygit",
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
      preset = "helix",
      layout = { align = "center" },
      show_help = true,
      plugins = {
        presets = {
          g = false,
        },
      },
      icons = {
        breadcrumb = "»",
        separator = "󰜴",
        group = "+",
        rules = {
          {
            plugin = "neogen",
            icon = " ",
            color = "blue",
          },
          { plugin = "neotest", icon = "󰙨 ", color = "red" },
          { pattern = "bookmark", icon = "󰸕 ", color = "yellow" },
          { plugin = "ssr.nvim", icon = " ", color = "blue" },
          { plugin = "vim-illuminate", icon = " ", color = "grey" },
          { plugin = "gx.nvim", icon = "󰇧 ", color = "blue" },

          { pattern = "delete", icon = " ", color = "blue" },
          { pattern = "xray", icon = " ", color = "purple" },
          { pattern = "clear", icon = " ", color = "red" },
          { pattern = "list", icon = " ", color = "grey" },
          { pattern = "hydra", icon = " ", color = "orange" },
          { pattern = "HYDRA", icon = " ", color = "orange" },
          { pattern = "save", icon = " ", color = "green" },
          { pattern = "outline", icon = " ", color = "purple" },
          { pattern = "trouble", icon = " ", color = "yellow" },
          { pattern = "vcs", icon = "󰊢 ", color = "red" },
          { pattern = "conflict", icon = " ", color = "cyan" },
          { pattern = "yazi", icon = " ", color = "yellow" },
          { pattern = "format", icon = " ", color = "cyan" },
          { pattern = "lazygit", icon = " ", color = "yellow" },
          { pattern = "open", icon = " ", color = "cyan" },
        },
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "ai" },
          { "<leader>b", group = "bookmarks" },
          { "<leader>c", group = "clear" },
          { "<leader>f", group = "file" },
          {
            "<leader>h",
            group = "local",
            icon = {
              icon = " ",
              color = "blue",
            },
          },
          { "<leader>l", group = "list" },
          {
            "<leader>n",
            group = "no",
            icon = { icon = " ", color = "red" },
          },
          { "<leader>p", group = "preview" },
          { "<leader>r", group = "remote", icon = " " },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "test/toggle" },
          { "<leader>v", group = "vcs" },
          { "<leader>w", group = "window" },
          { "<leader>x", group = "xray" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
        },
      },
      win = {
        border = "solid",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
  {
    "echasnovski/mini.move",
    opts = {
      mappings = {
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",
        line_left = "<C-h>",
        line_right = "<C-l>",
        line_down = "<C-j>",
        line_up = "<C-k>",
      },
    },
    keys = {
      { "<C-h>", mode = { "n", "v" } },
      { "<C-j>", mode = { "n", "v" } },
      { "<C-k>", mode = { "n", "v" } },
      { "<C-l>", mode = { "n", "v" } },
    },
  },
  {
    "kazhala/close-buffers.nvim",
    cmd = {
      "BDelete",
      "BWipeout",
    },
    opts = {
      filetype_ignore = {
        "dashboard",
        "NvimTree",
        "TelescopePrompt",
        "terminal",
        "toggleterm",
        "packer",
        "fzf",
      },
      preserve_window_layout = { "this" },
      next_buffer_cmd = function(windows)
        require("bufferline").cycle(1)
        local bufnr = vim.api.nvim_get_current_buf()
        for _, window in ipairs(windows) do
          vim.api.nvim_win_set_buf(window, bufnr)
        end
      end,
    },
    keys = function()
      local function redraw_all()
        vim.api.nvim_command("redrawstatus!")
        vim.api.nvim_command("redraw!")
      end
      return {
        {
          "<leader>ch",
          function()
            require("close_buffers").delete { type = "hidden", force = true }
            redraw_all()
          end,
          desc = "delete-hidden-buffers",
          mode = { "n", "v" },
        },
      }
    end,
  },
}
