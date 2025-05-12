---@type dotvim.core.plugin.PluginOption
return {
  "williamboman/mason.nvim",
  opts = {
    PATH = "append",
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
  event = { "VeryLazy", "BufFilePre", "BufNewFile" },
  config = function(_, opts)
    -- ---@type dotvim.utils.async
    -- local Async = require("dotvim.utils.async")
    -- ---@type dotvim.utils.fs
    -- local Fs = require("dotvim.utils.fs")
    --
    -- local last_update_marker = (function()
    --   local mason_settings = require("mason.settings").current
    --   local mason_root = mason_settings.install_root_dir
    --   local Path = require("plenary.path")
    --   local marker_file = Path:new(mason_root) / "registry-last-update"
    --   return tostring(marker_file)
    -- end)()
    --
    -- local check_registry_outdated = function()
    --   local interval = vim.F.if_nil(opts.extra.outdated_check_interval, 1)
    --   if interval < 0 then
    --     -- disable
    --     return false
    --   end
    --   local content = Fs.read_file(last_update_marker)
    --   local last_update = 0
    --   if content ~= nil then
    --     content = vim.trim(content)
    --     last_update = tonumber(content) or 0
    --   end
    --   local now = os.time(os.date("!*t") --[[@as osdateparam]])
    --   if now - last_update > 60 * 60 * 24 * interval then
    --     Fs.write_file(last_update_marker, tostring(now))
    --     return true
    --   end
    --   return false
    -- end
    --
    -- local function install_package(pkg)
    --   if pkg:is_installed() then
    --     return
    --   end
    --   local handle = pkg:install()
    --   handle:once(
    --     "closed",
    --     vim.schedule_wrap(function()
    --       if pkg:is_installed() then
    --         vim.notify(
    --           ("%s was successfully installed"):format(pkg),
    --           vim.log.levels.INFO,
    --           {
    --             title = "mason.nvim",
    --             render = "compact",
    --           }
    --         )
    --       else
    --         vim.notify(
    --           ("Failed to install %s"):format(pkg),
    --           vim.log.levels.ERROR,
    --           {
    --             title = "mason.nvim",
    --             render = "compact",
    --           }
    --         )
    --       end
    --     end)
    --   )
    -- end
    --
    -- local function check_package_outdated(pkg)
    --   local ok, new_version = Async.wrap(pkg.check_new_version)(pkg)
    --   if ok then
    --     return new_version.name
    --   end
    -- end
    --
    -- local function install_missing_or_update_packages()
    --   local registry = require("mason-registry")
    --   local outdated_packages = {}
    --   for _, name in ipairs(opts.extra.ensure_installed) do
    --     local pkg = registry.get_package(name)
    --     if pkg == nil then
    --       vim.notify(
    --         ("%s is not a Mason package. Please check your config"):format(name),
    --         vim.log.levels.WARN,
    --         {
    --           title = "mason.nvim",
    --           render = "compact",
    --         }
    --       )
    --     else
    --       if pkg:is_installed() then
    --         if opts.extra.update_installed_packages then
    --           if check_package_outdated(pkg) ~= nil then
    --             outdated_packages[#outdated_packages + 1] = name
    --           end
    --         end
    --       else
    --         install_package(pkg)
    --       end
    --     end
    --   end
    --   if #outdated_packages == 0 then
    --     vim.notify("All packages are up to date", vim.log.levels.INFO, {
    --       title = "mason.nvim",
    --       render = "compact",
    --     })
    --   end
    -- end
    --
    -- local do_setup = coroutine.wrap(function()
    --   if check_registry_outdated() then
    --     local ok, data = Async.wrap(require("mason-registry").update)()
    --     if ok then
    --       vim.notify("Mason-registry updated!", vim.log.levels.INFO, {
    --         title = "mason.nvim",
    --         render = "compact",
    --       })
    --     else
    --       vim.notify(
    --         "Mason-registry update failed, reason: " .. tostring(data),
    --         vim.log.levels.ERROR,
    --         {
    --           title = "mason.nvim",
    --           render = "compact",
    --         }
    --       )
    --     end
    --   end
    --   install_missing_or_update_packages()
    -- end)
    --
    local emit_user_mason_setup_done = function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "MasonSetupDone",
      })
      vim.g.dotvim_mason_setup_done = true
    end
    --
    -- if vim.fn.argc() == 0 then
    --   vim.defer_fn(function()
    --     require("mason").setup(opts)
    --     do_setup()
    --     emit_user_mason_setup_done()
    --   end, 200)
    -- else
    --   -- skip update, setup immediately
      require("mason").setup(opts)
      emit_user_mason_setup_done()
    -- end
  end,
  actions = function()
    ---@type dotvim.core.action
    local action = require("dotvim.core.action")
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
}
