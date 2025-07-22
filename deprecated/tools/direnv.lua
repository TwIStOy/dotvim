local M = {}

---@param bufnr number
---@return string?
function M.root(bufnr)
  local root = vim.fs.root(bufnr, ".envrc")
  return root
end

---@async
---@param args string[]
---@param cwd string?
---@return vim.SystemCompleted
local function direnv(args, cwd)
  local co = coroutine.running()
  local cmd = { "direnv" }
  cmd = vim.list_extend(cmd, args)
  vim.system(cmd, {
    cwd = cwd,
  }, function(out)
    vim.schedule(function()
      coroutine.resume(co, out)
    end)
  end)
  return coroutine.yield()
end

---@async
---@param args string[]
local function direnv_command(args)
  local root = M.root(0)
  if not root then
    return false
  end
  local out = direnv({ "status" }, root)
  return out.code == 0
end

---@async
---@return boolean
M.test = function()
  return direnv_command { "status" }
end

---@async
---@return boolean
M.allow = function()
  return direnv_command { "allow" }
end

---@async
---@return boolean
M.deny = function()
  return direnv_command { "deny" }
end

---@async
---@return table?
function M.dump()
  local root = M.root(0)
  if not root then
    return nil
  end
  local out = direnv({ "export", "json" }, root)
  if out.code ~= 0 then
    return nil
  end
  local envs = vim.json.decode(out.stdout)
  return envs
end

function M._test()
  local co = coroutine.create(M.dump)
  coroutine.resume(co)
  dv._wait_coroutine(co)
end

return M
