---@class dotvim.extra.search_everywhere
local M = {}

---@class dotvim.extra.search_everywhere.EntryColumn
---@field text string
---@field highlight? string

---@class dotvim.extra.search_everywhere.Entry
---@field filename? string
---@field pos? { lnum: integer, col: integer }
---@field preview "FilePos" | 'File' | "None"
---@field kind "Symbols" | "Files"
---@field columns (dotvim.extra.search_everywhere.EntryColumn|string)[]
---@field search_key? string

---@class dotvim.extra.search_everywhere.Opts
---@field project_files? dotvim.extra.search_everywhere.project_files.Opts

---@class dotvim.extra.search_everywhere.Context
---@field bufnr integer
---@field cwd Path
---@field opts dotvim.extra.search_everywhere.Opts

---@class dotvim.extra.search_everywhere.ProviderPollResult
---@field results dotvim.extra.search_everywhere.Entry[]
---@field complete boolean

---@param column dotvim.extra.search_everywhere.EntryColumn|string
---@return dotvim.extra.search_everywhere.EntryColumn
function M.normalize_column(column)
  if type(column) == "string" then
    return { text = column }
  end
  return column
end

local function fetch_providers(providers)
  local polls = providers
  local results = {}

  while #polls > 0 do
    local next_polls = {}
    for _, poll in ipairs(polls) do
      ---@type boolean, dotvim.extra.search_everywhere.ProviderPollResult
      local err, poll_result = coroutine.resume(poll)
      if err then
        vim.api.nvim_err_writeln("Error when polling provider: " .. err)
      else
        results = vim.list_extend(results, poll_result.results)
        if not poll_result.complete then
          next_polls[#next_polls + 1] = poll
        end
      end
    end
    polls = next_polls
    -- coroutine.yield()
    require("plenary.async").util.scheduler()
  end

  return results
end

return M
