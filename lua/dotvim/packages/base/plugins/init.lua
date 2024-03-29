---@type dotvim.core.plugin.PluginOption[]
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
    lazy = true,
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

      ---@type dora.config
      local config = require("dora.config")

      ---@type dora.core.action.ActionOption[]
      local actions = {
        {
          id = "toggleterm.toggle",
          title = "Toggle terminal",
          callback = "ToggleTerm",
          keys = { "<C-t>", desc = "toggle-terminal" },
        },
      }

      if config.integration.enabled("yazi") then
        actions[#actions + 1] = {
          id = "toggleterm.yazi",
          title = "Open Yazi",
          callback = function()
            local executable = config.nix.resolve_bin("yazi")
            if vim.fn.executable(executable) ~= 1 then
              vim.notify(
                "Command [yazi] not found!",
                vim.log.levels.ERROR,
                { title = "toggleterm.nvim" }
              )
              return
            end
            local root = vim.fn.getcwd()
            require("toggleterm.terminal").Terminal
              :new({
                cmd = "yazi",
                dir = root,
                direction = "float",
                close_on_exit = true,
                float_opts = { border = "none" },
                start_in_insert = true,
                hidden = true,
              })
              :open()
          end,
          keys = { "<leader>ff", desc = "toggle-yazi" },
        }
      end

      if config.integration.enabled("lazygit") then
        actions[#actions + 1] = {
          id = "toggleterm.lazygit",
          title = "Open lazygit",
          callback = function()
            local executable = config.nix.resolve_bin("lazygit")
            if vim.fn.executable(executable) ~= 1 then
              vim.notify(
                "Command [lazygit] not found!",
                vim.log.levels.ERROR,
                { title = "toggleterm.nvim" }
              )
              return
            end
            local repo_path = require("dora.lib").fs.git_repo_path()
            if repo_path == nil then
              vim.notify(
                "Not in a git repo!",
                vim.log.levels.ERROR,
                { title = "toggleterm.nvim" }
              )
              return
            end
            require("toggleterm.terminal").Terminal
              :new({
                cmd = "lazygit",
                dir = repo_path,
                direction = "float",
                close_on_exit = true,
                start_in_insert = true,
                float_opts = { border = "none" },
                on_close = function(t)
                  vim.schedule(function()
                    t:shutdown()
                  end)
                end,
              })
              :open()
          end,
          keys = { "<leader>g", desc = "toggle-lazygit" },
        }
      end

      return action.make_options {
        from = "toggleterm.nvim",
        category = "ToggleTerm",
        actions = actions,
      }
    end,
  },
}
