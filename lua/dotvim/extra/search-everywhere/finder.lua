---@class dotvim.extra.search_everywhere.UniversalFinder.Providers
---@field project_files dotvim.extra.search_everywhere.async_job.AsyncJob?
---@field workspace_symbols dotvim.extra.search_everywhere.async_job.AsyncJob?
---@field text dotvim.extra.search_everywhere.async_job.AsyncJob?

---@class dotvim.extra.search_everywhere.UniversalFinder
---@field static_results dotvim.extra.search_everywhere.Entry[]
---@field dynamic_results dotvim.extra.search_everywhere.Entry[]
---@field providers dotvim.extra.search_everywhere.UniversalFinder.Providers
---@field ctx dotvim.extra.search_everywhere.Context
local universal_finder = {}

---@type Path
local Path = require("plenary.path")

---@param ctx dotvim.extra.search_everywhere.Context
function universal_finder.new(ctx)
  local obj = {
    static_results = {},
    dynamic_results = {},
    ctx = ctx,
    providers = {},
  }

  setmetatable(obj, {
    __index = universal_finder,
    __call = function(t, ...)
      return t:_find(...)
    end,
  })

  return obj
end

function universal_finder:create_static_providers()
  if self.providers.project_files == nil then
    self.providers.project_files = require(
      "dotvim.extra.search-everywhere.providers.file"
    ).project_files.new(self.ctx)
  end
  if self.providers.workspace_symbols == nil then
    self.providers.workspace_symbols = require(
      "dotvim.extra.search-everywhere.providers.lsp"
    ).workspace_symbols.new(self.ctx)
  end
end

function universal_finder:create_dynamic_providers(prompt)
  if self.providers.text ~= nil then
    self.providers.text:close()
    self.providers.text = nil
  end
  if not prompt or prompt == "" then
    return
  end
  self.providers.text =
    require("dotvim.extra.search-everywhere.providers.text").text.new(
      prompt,
      self.ctx
    )
end

---@param provider dotvim.extra.search_everywhere.async_job.AsyncJob
function universal_finder:_poll_provider(provider)
  if coroutine.status(provider.thread) == "dead" then
    provider.thread = nil
    return nil
  end
  local succ, result = coroutine.resume(provider.thread)
  if not succ then
    vim.api.nvim_err_writeln("Error when polling thread: " .. result)
    provider.thread = nil
    return nil
  end
  return result
end

function universal_finder:poll_results()
  local new_entries = {}
  local project_files = self.providers.project_files
  if project_files and project_files.thread then
    local results = self:_poll_provider(project_files)
    if results then
      self.static_results = vim.list_extend(self.static_results, results)
      new_entries = vim.list_extend(new_entries, results)
    end
  end

  local workspace_symbols = self.providers.workspace_symbols
  if workspace_symbols and workspace_symbols.thread then
    local results = self:_poll_provider(workspace_symbols)
    if results then
      self.static_results = vim.list_extend(self.static_results, results)
      new_entries = vim.list_extend(new_entries, results)
    end
  end

  local text = self.providers.text
  if text and text.thread then
    local results = self:_poll_provider(text)
    if results then
      self.dynamic_results = vim.list_extend(self.dynamic_results, results)
      new_entries = vim.list_extend(new_entries, results)
    end
  end
  return new_entries
end

function universal_finder:is_complete()
  if self.providers.text and self.providers.text.thread then
    return false
  end
  if self.providers.project_files and self.providers.project_files.thread then
    return false
  end
  if
    self.providers.workspace_symbols
    and self.providers.workspace_symbols.thread
  then
    return false
  end
  return true
end

---@param ctx dotvim.extra.search_everywhere.Context
local function gen_entry_maker(ctx)
  ---@param entry dotvim.extra.search_everywhere.Entry
  ---@param idx number
  return function(entry, idx)
    ---@diagnostic disable-next-line: param-type-mismatch
    local path = Path.new(entry.filename)
    local root = Path.new(ctx.cwd)
    if not path:is_absolute() then
      path = root / path
    end
    return {
      value = entry,
      index = idx,
      ordinal = entry.search_key,
      display = function(t)
        return t.value.displayer {
          { t.value.kind, "Keyword" },
          unpack(t.value.columns),
        }
      end,
      ---@diagnostic disable-next-line: param-type-mismatch
      path = tostring(path),
      lnum = entry.pos and entry.pos.lnum,
    }
  end
end

function universal_finder:_find(prompt, process_result, process_complete)
  self.dynamic_results = {}

  self:create_static_providers()
  self:create_dynamic_providers(prompt)

  local entry_maker = gen_entry_maker(self.ctx)

  local next_tick = coroutine.create(function()
    local processed = 0

    local function yield_if_needed(entry)
      processed = processed + 1
      if processed % 100 == 0 then
        coroutine.yield()
      end
      local e = entry_maker(entry, processed)
      process_result(e)
    end

    for _, result in ipairs(self.static_results) do
      yield_if_needed(result)
    end
    for _, result in ipairs(self.dynamic_results) do
      yield_if_needed(result)
    end

    while not self:is_complete() do
      local new_entrie = self:poll_results()
      vim.iter(new_entrie):each(yield_if_needed)
      coroutine.yield()
    end

    process_complete()
  end)
  local fragment
  fragment = function()
    local succ, res = coroutine.resume(next_tick)
    if not succ then
      vim.api.nvim_err_writeln("Error when polling providers: " .. res)
      return
    end
    if coroutine.status(next_tick) ~= "dead" then
      vim.schedule(fragment)
    end
  end

  vim.defer_fn(function()
    fragment()
  end, 1)
end

function universal_finder:close()
  local project_files = self.providers.project_files
  if project_files then
    project_files:close()
  end

  local workspace_symbols = self.providers.workspace_symbols
  if workspace_symbols then
    workspace_symbols:close()
  end

  local text = self.providers.text
  if text then
    text:close()
  end
end

local M = {}
M.universal_finder = universal_finder

return M
