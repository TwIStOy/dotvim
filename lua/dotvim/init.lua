local dora_dev = os.getenv("HOME") .. "/Projects/nvim-plugins/dora.nvim"

local function install_missing_dora()
  local dora_path = vim.fn.stdpath("data") .. "/lazy/dora.nvim"

  if not vim.uv.fs_stat(dora_path) then
    vim
      .system({
        "git",
        "clone",
        "https://github.com/TwIStOy/dora.nvim.git",
        dora_path,
      })
      :wait()
  end

  if vim.fn.isdirectory(dora_dev) == 1 then
    vim.opt.rtp:prepend(dora_dev)
  else
    vim.opt.rtp:prepend(dora_path)
  end
end

local M = {}

local function load_nix_aware_file()
  local path = vim.fn.stdpath("config") .. "/nix-aware.json"
  if not not vim.uv.fs_stat(path) then
    local lib = require("dora.lib")
    local content = lib.fs.read_file(path)
    if content ~= nil then
      return vim.fn.json_decode(content)
    end
  end
  return {}
end

function M.setup(opts)
  install_missing_dora()

  ---@class dora
  local dora = require("dora")

  opts = opts or {}

  opts.packages = {
    "dora.packages._builtin",
    "dora.packages.coding",
    "dora.packages.editor",
    "dora.packages.treesitter",
    "dora.packages.lsp",
    "dora.packages.ui",
    "dora.packages.extra.ui",
    "dora.packages.extra.misc.tools",
    "dora.packages.extra.misc.darwin",
    "dora.packages.extra.editor",
    "dora.packages.extra.lang.cpp",
    "dora.packages.extra.lang.cmake",
    "dora.packages.extra.lang.lua",
    "dora.packages.extra.lang.latex",
    "dora.packages.extra.lang.markdown",
    "dora.packages.extra.lang.python",
    "dora.packages.extra.lang.rust",
    "dora.packages.extra.lang.dart",
    "dora.packages.extra.lang.typescript",
    "dora.packages.extra.lang.nix",
    "dora.packages.extra.misc.competitive-programming",
    "dora.packages.extra.misc.copilot",
    "dora.packages.extra.misc.wakatime",
    "dora.packages.extra.misc.rime",
    "dora.packages.extra.obsidian",

    "dotvim.packages._",
    "dotvim.packages.obsidian",
    "dotvim.packages.lsp",
    "dotvim.packages.editor",
  }

  if vim.uv.os_uname() == "Darwin" then
    table.insert(opts.packages, "dora.packages.extra.lang.swift")
    table.insert(opts.packages, "dora.packages.extra.misc.darwin")
  end

  opts.lazy = function(lazy_opts)
    if vim.fn.isdirectory(dora_dev) == 1 then
      lazy_opts.performance.rtp.paths = {
        dora_dev,
        os.getenv("HOME") .. "/.dotvim",
      }
    else
      table.insert(
        lazy_opts.performance.rtp.paths,
        os.getenv("HOME") .. "/.dotvim"
      )
    end

    -- try to resolve my custom plugins
    local function resolve_my_dev_plugins(plugin)
      local dev_base = os.getenv("HOME") .. "/Projects/nvim-plugins"
      local name = plugin.name
      local dev_path = dev_base .. "/" .. name
      if vim.fn.isdirectory(dev_path) == 1 then
        return dev_path
      end
    end
    if lazy_opts.dev ~= nil then
      local old_resolver = lazy_opts.dev.path
      lazy_opts.dev.path = function(plugin)
        local old_path = old_resolver(plugin)
        if old_path == "/dev/null/must_not_exists" then
          local dev_path = resolve_my_dev_plugins(plugin)
          if dev_path ~= nil then
            return dev_path
          end
        end
        return old_path
      end
    else
      lazy_opts.dev = {
        path = function(plugin)
          local dev_path = resolve_my_dev_plugins(plugin)
          if dev_path ~= nil then
            return dev_path
          end
          return "/dev/null/must_not_exists"
        end,
        patterns = { "/" }, -- hack to make sure all plugins are `dev`
        fallback = true,
      }
    end
  end

  opts.nix = load_nix_aware_file()

  dora.setup(opts)

  vim.cmd("colorscheme catppuccin")
end

return M
