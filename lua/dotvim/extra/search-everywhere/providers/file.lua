---@class dotvim.extra.search_everywhere.file
local M = {}

---@type dotvim.utils
local Utils = require("dotvim.utils")

local async_job = require("telescope._")
local LinesPipe = require("telescope._").LinesPipe

---@class dotvim.extra.search_everywhere.project_files.Opts
---@field hidden boolean
---@field no_ignore boolean
---@field follow boolean

---@param line string
---@return dotvim.extra.search_everywhere.Entry
local function make_entry(line)
  return {
    filename = line,
    preview = "File",
    kind = "Files",
    search_key = line,
  }
end

---@async
---@param ctx dotvim.extra.search_everywhere.Context
local function project_files(ctx)
  local command = { Utils.which("rg"), "--files", "--color", "never" }
  if vim.tbl_get(ctx, "opts", "hidden") then
    command[#command + 1] = "--hidden"
  end
  if vim.tbl_get(ctx, "opts", "no_ignore") then
    command[#command + 1] = "--no-ignore"
  end
  if vim.tbl_get(ctx, "opts", "follow") then
    command[#command + 1] = "--follow"
  end

  local stdout = LinesPipe()
  async_job.spawn {
    command = command,
    cwd = ctx.cwd,
    stdout = stdout,
  }

  local num_results = 0
  local results = {}
  for line in stdout:iter(false) do
    num_results = num_results + 1
    if num_results % 1000 then
      coroutine.yield {
        results = results,
        complete = false,
      }
      results = {}
    end

    local entry = make_entry(line)
    results[#results + 1] = entry
  end

  return {
    results = results,
    complete = true,
  }
end

---@param ctx dotvim.extra.search_everywhere.Context
function M.project_files(ctx)
  return coroutine.create(function()
    return project_files(ctx)
  end)
end

return M
