local M = {}

local Const = require("ht.core.const")

local start = vim.health.start
local ok = vim.health.ok
local warn = vim.health.warn
local error = vim.health.error

local function executable(exe)
  return vim.fn.executable(exe) == 1
end

local tools_required =
  { "rg", "fd", "bat", "delta", "cargo", "rustup", "stylua", "difft" }

local mason_bins = {
  "clangd",
  "clang-format",
  "black",
  "lua-language-server",
  "prettier",
  "stylua",
  "pyright-langserver",
}

function M.check()
  start("ht.dotvim")

  for _, tool in ipairs(tools_required) do
    if executable(tool) then
      ok(tool .. " installed")
    else
      warn(tool .. " not installed?")
    end
  end

  for _, bin in ipairs(mason_bins) do
    if executable(Const.mason_bin .. "/" .. bin) then
      ok(bin .. " installed")
    else
      warn(bin .. " not installed?")
    end
  end

  if vim.g.rime_ls_cmd == nil then
    error("rime_ls is not installed or specified")
  else
    ok("rime_ls_cmd specified at " .. vim.inspect(vim.g.rime_ls_cmd))
  end

  if vim.g.python3_host_prog == nil then
    error("python3_host_prog is not installed or specified")
  else
    ok("python3_host_prog specified at " .. vim.g.python3_host_prog)
    if vim.uv.fs_stat(vim.g.python3_host_prog) then
      ok("python3_host_prog executable found at " .. vim.g.python3_host_prog)
    else
      error(
        "python3_host_prog executable not found at " .. vim.g.python3_host_prog
      )
    end
  end
end

return M
