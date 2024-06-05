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
  local project_files = self.providers.project_files
  if project_files and project_files.thread then
    local results = self:_poll_provider(project_files)
    if results then
      self.static_results = vim.list_extend(self.static_results, results)
    end
  end

  local workspace_symbols = self.providers.workspace_symbols
  if workspace_symbols and workspace_symbols.thread then
    local results = self:_poll_provider(workspace_symbols)
    if results then
      self.static_results = vim.list_extend(self.static_results, results)
    end
  end

  local text = self.providers.text
  if text and text.thread then
    local results = self:_poll_provider(text)
    if results then
      self.dynamic_results = vim.list_extend(self.dynamic_results, results)
    end
  end
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

function universal_finder:_find(prompt, process_result, process_complete)
  for _, result in ipairs(self.static_results) do
    process_result(result)
  end
  self.dynamic_results = {}

  self:create_static_providers()
  self:create_dynamic_providers(prompt)

  local next_tick = coroutine.create(function()
    while not self:is_complete() do
      self:poll_results()
      vim.iter(self.static_results):each(process_result)
      vim.iter(self.dynamic_results):each(process_result)
      coroutine.yield()
    end
  end)
  local fragment
  fragment = function()
    local succ, res = coroutine.resume(next_tick)
    if not succ then
      vim.api.nvim_err_writeln("Error when polling providers: " .. res)
      return
    end
    if not self:is_complete() and coroutine.status(next_tick) ~= "dead" then
      vim.schedule(fragment)
    else
      process_complete()
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
