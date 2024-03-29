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
    "williamboman/mason.nvim",
    opts = {
      PATH = "skip",
      ui = {
        icons = {
          package_installed = " ",
          package_pending = " ",
          package_uninstalled = " ",
        },
      },
      extra = {
        outdated_check_interval = 1, -- in days
        ensure_installed = {},
        update_installed_packages = true,
      },
    },
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    dependencies = {
      "plenary.nvim",
    },
    event = "VeryLazy",
    config = function(_, opts)
      ---@type dora.lib
      local lib = require("dora.lib")

      local last_update_marker = (function()
        local mason_settings = require("mason.settings").current
        local mason_root = mason_settings.install_root_dir
        local Path = require("plenary.path")
        local marker_file = Path:new(mason_root) / "registry-last-update"
        return tostring(marker_file)
      end)()

      local check_registry_outdated = function()
        local interval = vim.F.if_nil(opts.extra.outdated_check_interval, 1)
        if interval < 0 then
          -- disable
          return false
        end
        local content = lib.fs.read_file(last_update_marker)
        local last_update = 0
        if content ~= nil then
          content = vim.trim(content)
          last_update = tonumber(content) or 0
        end
        local now = os.time(os.date("!*t") --[[@as osdateparam]])
        if now - last_update > 60 * 60 * 24 * interval then
          lib.fs.write_file(last_update_marker, tostring(now))
          return true
        end
        return false
      end

      local function install_package(pkg)
        if pkg:is_installed() then
          return
        end
        local handle = pkg:install()
        handle:once(
          "closed",
          vim.schedule_wrap(function()
            if pkg:is_installed() then
              vim.notify(
                ("%s was successfully installed"):format(pkg),
                vim.log.levels.INFO,
                {
                  title = "mason.nvim",
                  render = "compact",
                }
              )
            else
              vim.notify(
                ("Failed to install %s"):format(pkg),
                vim.log.levels.ERROR,
                {
                  title = "mason.nvim",
                  render = "compact",
                }
              )
            end
          end)
        )
      end

      local function check_package_outdated(pkg)
        local ok, new_version = lib.async.wrap(pkg.check_new_version)(pkg)
        if ok then
          return new_version.name
        end
      end

      local function install_missing_or_update_packages()
        local registry = require("mason-registry")
        local outdated_packages = {}
        for _, name in ipairs(opts.extra.ensure_installed) do
          local pkg = registry.get_package(name)
          if pkg == nil then
            vim.notify(
              ("%s is not a Mason package. Please check your config"):format(
                name
              ),
              vim.log.levels.WARN,
              {
                title = "mason.nvim",
                render = "compact",
              }
            )
          else
            if pkg:is_installed() then
              if opts.extra.update_installed_packages then
                if check_package_outdated(pkg) ~= nil then
                  outdated_packages[#outdated_packages + 1] = name
                end
              end
            else
              install_package(pkg)
            end
          end
        end
      end

      local do_setup = coroutine.wrap(function()
        if check_registry_outdated() then
          local ok, data = lib.async.wrap(require("mason-registry").update)()
          if ok then
            vim.notify("Mason-registry updated!", vim.log.levels.INFO, {
              title = "mason.nvim",
              render = "compact",
            })
          else
            vim.notify(
              "Mason-registry update failed, reason: " .. tostring(data),
              vim.log.levels.ERROR,
              {
                title = "mason.nvim",
                render = "compact",
              }
            )
          end
        end
        install_missing_or_update_packages()
      end)

      vim.defer_fn(function()
        require("mason").setup(opts)
        do_setup()
      end, 200)
    end,
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "mason.nvim",
        category = "Mason",
        actions = {
          {
            id = "mason.open-window",
            title = "Open mason window",
            callback = "Mason",
          },
          {
            id = "mason.install",
            title = "Install a tool",
            callback = "MasonInstall",
          },
          {
            id = "mason.update",
            title = "Update a tool",
            callback = "MasonUpdate",
          },
          {
            id = "mason.uninstall",
            title = "Uninstall a tool",
            callback = "MasonUninstall",
          },
          {
            id = "mason.uninstall-all",
            title = "Uninstall all tools",
            callback = "MasonUninstallAll",
          },
          {
            id = "mason.show-log",
            title = "Show mason log",
            callback = "MasonLog",
          },
        },
      }
    end,
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
