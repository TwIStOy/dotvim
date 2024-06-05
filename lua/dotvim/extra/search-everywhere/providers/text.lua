---@class dotvim.extra.search_everywhere.text
local M = {}

---@param line string
---@return dotvim.extra.search_everywhere.Entry?
local function make_entry(line)
  local object = vim.json.decode(line)
  if object["type"] ~= "match" then
    return
  end

  local filename = vim.tbl_get(object, "data", "path", "text")
  local line_number = vim.tbl_get(object, "data", "line_number")
  local text = vim.tbl_get(object, "data", "lines", "text")

  ---@type dotvim.extra.search_everywhere.Entry
  return {
    filename = filename,
    pos = { lnum = line_number, col = 0 },
    preview = "FileLine",
    kind = "Files",
    search_key = text,
    columns = {
      { text = filename },
      { text = line_number },
      { text = text },
    },
  }
end

---@type dotvim.utils
local Utils = require("dotvim.utils")

---@class dotvim.extra.search_everywhere.text.Finder
---@field finished boolean
---@field job vim.SystemObj
local finder = {}

---@param prompt string
---@param ctx dotvim.extra.search_everywhere.Context
function finder.new(prompt, ctx)
  local cmd = {
    Utils.which("rg"),
    "--smart-case",
    "--json",
    "--",
    prompt,
  }
  local self = setmetatable({
    prompt = prompt,
    stdout = "",
    finished = false,
  }, { __index = finder })
  local job = vim.system(cmd, {
    cwd = tostring(ctx.cwd),
    stdout = function(err, data)
      self:on_stdout(err, data)
    end,
  }, function()
    self.finished = true
  end)
  self.job = job
  self.thread = coroutine.create(function()
    return self:_poll()
  end)
  return self
end

function finder:on_stdout(_, data)
  if data then
    self.stdout = self.stdout .. data
    self.stdout = string.gsub(self.stdout, "\r", "")
  end
end

function finder:next_line()
  local index = nil
  index = string.find(self.stdout, "\n", index, true)
  if index then
    local line = string.sub(self.stdout, 1, index - 1)
    self.stdout = string.sub(self.stdout, index + 1)
    return line
  end
  return nil
end

function finder:close()
  if not self.finished then
    self.job:kill(9)
  end
end

function finder:_poll()
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
      if entry then
        results[#results + 1] = entry
      end
    end
    coroutine.yield {}
  until self.finished
  while true do
    local line = self:next_line()
    if not line then
      break
    end
    local entry = make_entry(line)
    if entry then
      results[#results + 1] = entry
    end
  end
  return results
end

M.text = finder

return M
