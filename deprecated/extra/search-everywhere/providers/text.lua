---@class dotvim.extra.search_everywhere.text
local M = {}

local displayer = require("telescope.pickers.entry_display").create {
  separator = "  ",
  items = {
    { width = 9, right_justify = true },
    { width = 20 },
    { remaining = true },
  },
}

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
  text = text:match("^[\n]*(.*[^\n])") or ""

  ---@type dotvim.extra.search_everywhere.Entry
  return {
    filename = filename,
    pos = { lnum = line_number, col = 0 },
    preview = "FileLine",
    kind = "Text",
    search_key = text,
    displayer = displayer,
    columns = {
      filename .. ":" .. line_number,
      text,
    },
  }
end

---@type dotvim.utils
local Utils = require("dotvim.utils")

---@class dotvim.extra.search_everywhere.text.Finder
---@field finished boolean
---@field job vim.SystemObj
---@field private lines string[]
local finder = {}

---@param prompt string
---@param ctx dotvim.extra.search_everywhere.Context
---@param process_result fun(entry: dotvim.extra.search_everywhere.Entry)
function finder.new(prompt, ctx, process_result)
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
    lines = {},
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
    return self:_poll(process_result)
  end)
  return self
end

function finder:on_stdout(_, data)
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
  if not self.finished and self.job then
    self.job:kill(9)
  end
end

function finder:_poll(process_result)
  local num_results = 1

  while true do
    local line = self.lines[num_results]
    if line then
      if num_results % 500 == 0 then
        coroutine.yield()
      end
      local entry = make_entry(line)
      if entry then
        process_result(entry)
      end
      num_results = num_results + 1
    else
      if self.finished then
        return
      end
      coroutine.yield()
    end
  end
end

M.text = finder

return M
