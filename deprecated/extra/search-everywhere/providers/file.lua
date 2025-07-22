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
    lines = {},
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
    data = string.gsub(data, "\r", "")
    self.stdout = self.stdout .. data

    while true do
      local line = self:next_line()
      if line then
        self.lines[#self.lines + 1] = line
      else
        return
      end
    end
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
  local num_results = 1
  local results = {}

  while true do
    local line = self.lines[num_results]
    if line then
      if num_results % 500 == 0 then
        coroutine.yield(results)
        results = {}
      end
      local entry = make_entry(line)
      if entry then
        results[#results + 1] = entry
      end
      num_results = num_results + 1
    else
      if self.finished then
        return results
      end
      coroutine.yield(results)
      results = {}
    end
  end
end

M.project_files = project_files

return M
