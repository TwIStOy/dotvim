local M = {}

local start = vim.health.start
local ok = vim.health.ok
local warn = vim.health.warn
local error = vim.health.error

local function executable(exe)
  return vim.fn.executable(exe) == 1
end

local tools_required =
  { "rg", "fd", "bat", "delta", "cargo", "rustup", "stylua", "difft" }

function M.check()
  start("ht.dotvim")

  for _, tool in ipairs(tools_required) do
    if executable(tool) then
      ok(tool .. " installed")
    else
      warn(tool .. " not installed?")
    end
  end

  if vim.g.compiled_llvm_clang_directory == nil then
    error("libclang path not specified")
  else
    ok("libclang path specified at " .. vim.g.compiled_llvm_clang_directory)
    local clangd_exe = vim.g.compiled_llvm_clang_directory .. "/bin/clangd"
    if vim.uv.fs_stat(clangd_exe) then
      ok("clangd executable found at " .. clangd_exe)
    else
      warn("clangd executable not found at " .. clangd_exe)
    end
  end

  if vim.g.lua_language_server_cmd == nil then
    error("lua_language_server is not installed or specified")
  else
    ok(
      "lua_language_server_cmd specified at "
        .. vim.inspect(vim.g.lua_language_server_cmd)
    )
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
