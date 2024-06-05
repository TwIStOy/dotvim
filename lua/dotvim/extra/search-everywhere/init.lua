---@class dotvim.extra.search_everywhere
local M = {}

---@class dotvim.extra.search_everywhere.EntryColumn
---@field text string
---@field highlight? string

---@class dotvim.extra.search_everywhere.Entry
---@field filename? string
---@field pos? { lnum: integer, col: integer }
---@field preview "FilePos" | 'FileLine' | 'File' | "None"
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

-- local function fetch_providers(providers)
--   local polls = providers
--   local results = {}
--
--   while #polls > 0 do
--     local next_polls = {}
--     for _, poll in ipairs(polls) do
--       ---@type boolean, dotvim.extra.search_everywhere.ProviderPollResult
--       local succ, poll_result = coroutine.resume(poll)
--       if not succ then
--         vim.api.nvim_err_writeln("Error when polling provider: " .. poll_result)
--       else
--         vim.api.nvim_out_write(
--           "Poll result: " .. vim.inspect(poll_result) .. "\n"
--         )
--         results = vim.list_extend(results, poll_result)
--         if coroutine.status(poll) ~= "dead" then
--           next_polls[#next_polls + 1] = poll
--         end
--       end
--     end
--     polls = next_polls
--     coroutine.yield()
--   end
--
--   return results
-- end

-- function M.test()
--   local providers = {}
--   providers[#providers + 1] =
--     require("dotvim.extra.search-everywhere.providers.file").project_files {
--       cwd = vim.uv.cwd(),
--       opts = {
--         hidden = true,
--         no_ignore = true,
--         follow = true,
--       },
--     }
--   local co = coroutine.create(function()
--     fetch_providers(providers)
--   end)
--   local next_tick
--   local count = 0
--   next_tick = function()
--     vim.print("Tick " .. count)
--     count = count + 1
--     vim.defer_fn(function()
--       local succ, msg = coroutine.resume(co)
--       if not succ then
--         vim.api.nvim_err_writeln("Error when polling provider: " .. msg)
--       end
--       if coroutine.status(co) ~= "dead" then
--         next_tick()
--       end
--     end, 1)
--   end
--   next_tick()
-- end

function M.test()
  local ctx = {
    cwd = vim.uv.cwd(),
    opts = {
      hidden = true,
      no_ignore = true,
      follow = true,
    },
  }
  local finder =
    require("dotvim.extra.search-everywhere.finder").universal_finder.new(ctx)
  finder("test", function(entry)
    vim.print(entry)
  end, function()
    vim.print("Complete")
  end)
end

return M
