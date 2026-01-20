---@diagnostic disable: undefined-global

---@module 'dotvim.commons.nix'
local M = {}

local Fs = require("dotvim.commons.fs")
local Str = require("dotvim.commons.string")
local Fn = require("dotvim.commons.fn")

-- Cache for nix plugin packages to avoid repeated nix-store calls
---@type table<string, {path: string}>|nil
local nix_packages_cache = nil

---Get all installed vim plugin packages from nix
---@return table<string, {path: string}>
function M.get_all_vimplugin_packages()
  -- Return cached result if available
  if nix_packages_cache then
    return nix_packages_cache
  end

  local result = {}

  -- Get nix-managed plugins directly from nix-store
  local nix_cmd =
    { "nix-store", "--query", "--requisites", "/run/current-system" }
  local nix_result = vim.system(nix_cmd, { text = true }):wait()

  if nix_result.code == 0 and nix_result.stdout then
    local nix_plugins = Str.split(nix_result.stdout, "\n", { trimempty = true })

    for _, plugin_path in ipairs(nix_plugins) do
      if plugin_path:find("vimplugin%-") then
        -- Extract plugin name from nix store path
        local plugin_name = plugin_path:match("vimplugin%-(.+)%-")
        if plugin_name then
          result[plugin_name] = {
            path = plugin_path,
          }
        end
      end
    end
  end

  -- Cache the result for subsequent calls
  nix_packages_cache = result
  return result
end

---Clear the nix plugin packages cache
---Forces the next call to get_all_vimplugin_packages to re-query nix-store
function M.clear_vimplugin_cache()
  nix_packages_cache = nil
end

local function in_nix_env()
  -- Check if the NIX_PATH environment variable is set
  if vim.env.NIX_PATH then
    return true
  end

  -- Check if the system is running under NixOS
  local os_release = Fs.read_file("/etc/os-release")
  if os_release and os_release:find("NixOS") then
    return true
  end

  -- Check for Nix-specific directories
  local nix_dirs = { "/run/current-system" }
  for _, dir in ipairs(nix_dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      return true
    end
  end

  return false
end

---Check if the current environment is a Nix environment
M.in_nix_env = Fn.invoke_once(in_nix_env)

local nix_aware_cache = nil
local function load_nix_aware_configs()
  local path = vim.fn.stdpath("config") .. "/nix-aware.json"
  ---@diagnostic disable-next-line: undefined-field
  if not not vim.uv.fs_stat(path) then
    local content = Fs.read_file(path)
    if content ~= nil then
      return vim.fn.json_decode(content)
    end
  end
  return {}
end

--[[
"nix_aware_config" is generated from the nix configuration on NixOS and nix-darwin.

Structure:
- bin: Map of binary names to their executable paths
- libs: Map of library names to their paths
- pkgs: Map of plugins names to their paths

Example:
{
  "bin": {
    "beancount-language-server": "/nix/store/2l5fnbqscvm13fv3lrs3azr8iypfmj2d-beancount-language-server-1.4.1/bin/beancount-language-server",
    "black": "/nix/store/p6bv8lkgq7vrmwk9j8212j57d8ck78z1-python3.13-black-25.1.0/bin/black",
    "clang-format": "/nix/store/ywx0xix8cck7g3kvlnbh51lhwxh5xvqm-clang-21.1.7/bin/clang-format",
    "clangd": "/nix/store/9lcdkdv93baanifhp26mc8g26zh08dix-clang-tools-21.1.7/bin/clangd",
    "emmylua-check": "/nix/store/2iw2xn19pq7gfg4hf7jax9ikp4bch1wc-emmylua_check-0.19.0/bin/emmylua-check",
    "emmylua-ls": "/nix/store/8b8635d6v13w879mii5vngxyswvrj7mr-emmylua_ls-0.19.0/bin/emmylua-ls",
    "fzf": "/nix/store/2qzpswmq7v8zdq12cbh65r156c77fr1h-fzf-0.67.0/bin/fzf",
    "helm-ls": "/nix/store/2w1wkhpfsrv5x4w7f3awdwigf1f79x9q-helm-ls-0.5.4/bin/helm-ls",
    "jdtls": "/nix/store/zrwc00snjy5h9kjiinhm22d0b3xyrqfw-jdt-language-server-1.54.0/bin/jdtls",
    "libgit2": "/nix/store/r7vq6mkh6jpp6qnjm9ic6gbgrb1vgsjf-libgit2-1.9.2-lib/bin/libgit2",
    "lua-language-server": "/nix/store/rg5s6wq16fqpyld7rjm8cyhgl4lq75zj-lua-language-server-3.16.1/bin/lua-language-server",
    "rust-analyzer": "/nix/store/r1hvxj7f823k3kamjwpw3a3y76rv7qar-rust-analyzer-2025-10-28/bin/rust-analyzer",
    "rustfmt": "/nix/store/arbhq0474gzmrqbn003m5ry02ibj21w1-rustfmt-1.91.1/bin/rustfmt",
    "statix": "/nix/store/1awapr4r0mrkyqfn5hcdax9ygriiv73x-statix-0.5.8/bin/statix",
    "stylua": "/nix/store/75mx9j13z3w7mm47v975v9zvgdp9x2ra-stylua-2.3.1/bin/stylua",
    "taplo": "/nix/store/lkz6l5m32a06yakkx83wsa5vwc309w2m-taplo-0.10.0/bin/taplo",
    "vscode-css-language-server": "/nix/store/amyg4qdcbi6fq06547jq4r0wl48gs5zh-vscode-langservers-extracted-4.10.0/bin/vscode-css-language-server",
    "vscode-eslint-language-server": "/nix/store/amyg4qdcbi6fq06547jq4r0wl48gs5zh-vscode-langservers-extracted-4.10.0/bin/vscode-eslint-language-server",
    "vscode-html-language-server": "/nix/store/amyg4qdcbi6fq06547jq4r0wl48gs5zh-vscode-langservers-extracted-4.10.0/bin/vscode-html-language-server",
    "vscode-json-language-server": "/nix/store/amyg4qdcbi6fq06547jq4r0wl48gs5zh-vscode-langservers-extracted-4.10.0/bin/vscode-json-language-server",
    "vscode-markdown-language-server": "/nix/store/amyg4qdcbi6fq06547jq4r0wl48gs5zh-vscode-langservers-extracted-4.10.0/bin/vscode-markdown-language-server",
    "xmllint": "/nix/store/4qfb3xm18gfgwxwz640n3665q48qrl51-libxml2-2.15.1-bin/bin/xmllint",
    "yaml-language-server": "/nix/store/73x6623rd0n78k1mwc0y2gc4398f3nfs-yaml-language-server-1.19.2/bin/yaml-language-server",
    "zls": "/nix/store/8cyca7ngpx4af3akzw06vsq6rfnz3ayy-zls-0.15.1/bin/zls"
  },
  "libs": {
    "magick": "/nix/store/fywfa4zjiwm3y2yrbhscxr86dx00a6zz-luajit2.1-magick-1.6.0-1",
    "tiktoken_core": "/nix/store/b8c4qccb0gxy1165g9y07v8jh131hba6-luajit2.1-tiktoken_core-0.2.5-1"
  },
  "pkgs": {
    "avante-nvim": "/nix/store/chxh7lgpknp2ihwcpv726sb3l87anak3-vimplugin-avante.nvim-0.0.27-unstable-2026-01-04",
    "codesnap-nvim": "/nix/store/hmvgpjjj51vqbh6388nn25702sz9iq6d-vimplugin-codesnap.nvim-2.0.0",
    "markdown-preview-nvim": "/nix/store/2chxmlpyhhjv8qivaskciv4dx2ffxg4q-vimplugin-markdown-preview.nvim-0.0.10-unstable-2023-10-17",
    "rest-nvim": "/nix/store/zg0rndsdb54l9ri1vj9klphd636ikqsz-vimplugin-luajit2.1-rest.nvim-3.13.0-1-unstable-3.13.0-1",
    "telescope-fzf-native-nvim": "/nix/store/bhl9jiddp1rgmbnzryzww593g9wrr53i-vimplugin-telescope-fzf-native.nvim-0-unstable-2025-11-07"
  },
  "try_nix_only": true
}

If a plugin is managed by nix, should use the path from pkgs for loading it instead of the default path.
--]]
function M.get_nix_aware_config()
  if not nix_aware_cache then
    nix_aware_cache = load_nix_aware_configs()
  end
  return nix_aware_cache
end

return M
