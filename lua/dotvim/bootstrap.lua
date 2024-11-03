local function install_missing_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  ---@diagnostic disable-next-line: undefined-field
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.rtp:prepend(lazypath)
end

local function def_command()
  vim.api.nvim_create_user_command("UpdateNixPluginPackages", function()
    local Utils = require("dotvim.utils")
    Utils.nix.update_nix_plugin_packages()
  end, {})
end

---@class dotvim.bootstrap
local M = {}

local enabled_packages = {
  "base",
  "coding",
  "editor",
  "lsp",
  "theme",
  "treesitter",
  "ui",
  "extra.languages.cmake",
  "extra.languages.cpp",
  "extra.languages.dart",
  "extra.languages.latex",
  "extra.languages.lua",
  "extra.languages.markdown",
  "extra.languages.nix",
  "extra.languages.python",
  "extra.languages.rust",
  -- "extra.languages.swift",
  "extra.languages.typescript",
  "extra.languages.json",
  "extra.languages.yaml",
  "extra.languages.toml",
  "extra.misc.competitive-programming",
  "extra.misc.ai",
  "extra.misc.rime",
  "extra.misc.devdocs",
  "extra.misc.rest",
}

function M.setup()
  ---@type dotvim.core
  local Core = require("dotvim.core")
  ---@type dotvim.utils
  local Utils = require("dotvim.utils")

  -- set mapleader at very beginning of profile
  vim.api.nvim_set_var("mapleader", " ")

  for _, pkg in ipairs(enabled_packages) do
    Core.package.load_package(pkg)
  end
  ---@diagnostic disable-next-line: undefined-field
  if vim.uv.os_uname().sysname == "Darwin" then
    Core.package.load_package("extra.misc.darwin")
  end

  local specs = {}
  local packages = Core.package.sort_loaded_packages()
  local processed = {}
  for _, pkg in ipairs(packages) do
    for _, plug_opts in ipairs(pkg:plugins()) do
      specs[#specs + 1] = Core.plugin.fix_cond(plug_opts, processed)
    end
  end

  install_missing_lazy()

  Utils.lazy.setup_on_lazy_plugins(function()
    for _, _plugin in pairs(require("lazy.core.config").spec.plugins) do
      local plugin = _plugin --[[@as dotvim.core.plugin.PluginOption]]
      if
        ---@diagnostic disable-next-line: undefined-field
        (plugin._.kind ~= "disabled" or plugin._.kind ~= "clean")
        and plugin.actions ~= nil
      then
        -- inject keys defined in actions
        ---@type LazyKeysSpec[]
        local all_keys
        if plugin.keys == nil then
          all_keys = {}
          ---@diagnostic disable-next-line: param-type-mismatch
        elseif vim.isarray(plugin.keys) then
          all_keys = plugin.keys --[[ @as LazyKeysSpec[] ]]
        else
          ---@diagnostic disable-next-line: assign-type-mismatch
          all_keys = { plugin.keys }
        end
        local actions
        if type(plugin.actions) == "function" then
          actions = plugin.actions()
          ---@diagnostic disable-next-line: param-type-mismatch
        elseif vim.isarray(plugin.actions) then
          actions = plugin.actions
        else
          actions = { plugin.actions }
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        for _, action_spec in ipairs(actions) do
          ---@diagnostic disable-next-line: param-type-mismatch
          local action = Core.action.new_action(action_spec)
          Core.registry.register_action(action)
          vim.list_extend(all_keys, action:into_lazy_keys_spec())
        end
        plugin.keys = all_keys
      end
    end
  end)

  local lazy_opts = {
    spec = specs,
    change_detection = { enabled = false },
    install = {
      missing = true,
    },
    rocks = {
      enabled = false,
    },
    performance = {
      cache = { enabled = true },
      rtp = {
        paths = {
          os.getenv("HOME") .. "/.dotvim",
        },
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
          "spellfile",
        },
      },
    },
  }

  Utils.lazy.fix_valid_fields()

  if Utils.nix.is_nix_managed() then
    lazy_opts.dev = {
      path = function(plugin)
        local name = Core.plugin.guess_name(plugin)
        local dev_path = os.getenv("HOME") .. "/Projects/nvim-plugins/" .. name
        ---@diagnostic disable-next-line: undefined-field
        if not not vim.uv.fs_stat(dev_path) then
          return dev_path
        end
        local pname = Utils.nix.normalize_plugin_pname(plugin)
        local resolved_path = Utils.nix.resolve_plugin(pname)
        if resolved_path ~= nil then
          return resolved_path
        end
        return "/dev/null/must_not_exists"
      end,
      patterns = { "/" }, -- hack to make sure all plugins are `dev`
      fallback = true,
    }
  else
    lazy_opts.dev = {
      path = function(plugin)
        local name = Core.plugin.guess_name(plugin)
        local dev_path = os.getenv("HOME") .. "/Projects/nvim-plugins/" .. name
        ---@diagnostic disable-next-line: undefined-field
        if vim.uv.fs_stat(dev_path) then
          return dev_path
        end
        return "/dev/null/must_not_exists"
      end,
      patterns = { "/" }, -- hack to make sure all plugins are `dev`
      fallback = true,
    }
  end

  -- before setup, init base46 cache folder
  -- vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

  require("lazy").setup(lazy_opts)

  for _, pkg in ipairs(packages) do
    pkg:setup()
  end

  def_command()
end

return M
