---@class dotvim.extra.search_everywhere.file
local M = {}

---@type dotvim.utils
local Utils = require("dotvim.utils")

local displayer = require("telescope.pickers.entry_display").create {
  separator = "  ",
  items = {
    { width = 9, right_justify = true },
    { remaining = true },
  },
}

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
    displayer = displayer,
    columns = {
      line,
    },
  }
end

local project_files = {}

function project_files.new(ctx)
  local self = setmetatable({
    finished = false,
    job = nil,
    stdout = "",
  }, {
    __index = project_files,
  })
  local cmd = { Utils.which("rg"), "--files", "--color", "never" }
  if vim.tbl_get(ctx, "opts", "hidden") then
    cmd[#cmd + 1] = "--hidden"
  end
  if vim.tbl_get(ctx, "opts", "no_ignore") then
    cmd[#cmd + 1] = "--no-ignore"
  end
  if vim.tbl_get(ctx, "opts", "follow") then
    cmd[#cmd + 1] = "--follow"
  end

  self.job = vim.system(cmd, {
    cwd = tostring(ctx.cwd),
    stdout = function(...)
      self:on_stdout(...)
    end,
    text = true,
  }, function()
    self.finished = true
  end)

  self.thread = coroutine.create(function()
    return self:poll()
  end)

  return self
end

function project_files:close()
  if not self.finished and self.job then
    self.job:kill(9)
    self.finished = true
  end
end

function project_files:on_stdout(_, data)
  if data then
    self.stdout = self.stdout .. data
    self.stdout = string.gsub(self.stdout, "\r", "")
  end
end

function project_files:next_line()
  local index = nil
  index = string.find(self.stdout, "\n", index, true)
  if index then
    local line = string.sub(self.stdout, 1, index - 1)
    self.stdout = string.sub(self.stdout, index + 1)
    return line
  end
  return nil
end

function project_files:poll()
  local num_results = 0
  local results = {}

  repeat
    local line = self:next_line()
    if line then
      num_results = num_results + 1
      if num_results % 1000 then
        coroutine.yield(results)
        results = {}
      end

      local entry = make_entry(line)
      results[#results + 1] = entry
    end
    coroutine.yield {}
  until self.finished
  while true do
    local line = self:next_line()
    if not line then
      break
    end
    local entry = make_entry(line)
    results[#results + 1] = entry
  end

  return results
end

-- ---@async
-- ---@param ctx dotvim.extra.search_everywhere.Context
-- local function project_files(ctx)
--   vim.print("project_files")
--   local cmd = { Utils.which("rg"), "--files", "--color", "never" }
--   if vim.tbl_get(ctx, "opts", "hidden") then
--     cmd[#cmd + 1] = "--hidden"
--   end
--   if vim.tbl_get(ctx, "opts", "no_ignore") then
--     cmd[#cmd + 1] = "--no-ignore"
--   end
--   if vim.tbl_get(ctx, "opts", "follow") then
--     cmd[#cmd + 1] = "--follow"
--   end
--
--   local stdout = ""
--   local finished = false
--
--   local function on_stdout(err, data)
--     if data then
--       stdout = stdout .. data
--       stdout = string.gsub(stdout, "\r", "")
--     end
--   end
--
--   local function on_exit(out)
--     finished = true
--   end
--
--   local function next_line()
--     local index = nil
--     index = string.find(stdout, "\n", index, true)
--     vim.print { stdout, index }
--     if index then
--       local line = string.sub(stdout, 1, index - 1)
--       stdout = string.sub(stdout, index + 1)
--       return line
--     end
--     return nil
--   end
--
--   vim.system(cmd, {
--     cwd = tostring(ctx.cwd),
--     stdout = on_stdout,
--     text = true,
--   }, on_exit)
--
--   local num_results = 0
--   local results = {}
--
--   repeat
--     local line = next_line()
--     if line then
--       num_results = num_results + 1
--       if num_results % 1000 then
--         coroutine.yield(results)
--         results = {}
--       end
--
--       local entry = make_entry(line)
--       results[#results + 1] = entry
--     end
--     coroutine.yield {}
--   until finished
--   while true do
--     local line = next_line()
--     if not line then
--       break
--     end
--     local entry = make_entry(line)
--     results[#results + 1] = entry
--   end
--
--   return results
-- end
--
-- ---@param ctx dotvim.extra.search_everywhere.Context
-- function M.project_files(ctx)
--   return coroutine.create(function()
--     return project_files(ctx)
--   end)
-- end

M.project_files = project_files

return M
