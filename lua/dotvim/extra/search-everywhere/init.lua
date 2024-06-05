---@class dotvim.extra.search_everywhere
local M = {}

---@class dotvim.extra.search_everywhere.Entry
---@field filename? string
---@field pos? { lnum: integer, col: integer }
---@field preview "FilePos" | 'FileLine' | 'File' | "None"
---@field kind "Symbols" | "Files" | 'Text'
---@field columns (string[]|string)[]
---@field search_key string

---@class dotvim.extra.search_everywhere.Opts
---@field project_files? dotvim.extra.search_everywhere.project_files.Opts

---@class dotvim.extra.search_everywhere.Context
---@field bufnr integer
---@field cwd Path
---@field opts dotvim.extra.search_everywhere.Opts

---@class dotvim.extra.search_everywhere.ProviderPollResult
---@field results dotvim.extra.search_everywhere.Entry[]
---@field complete boolean

function M.open_telescope()
  local ctx = {
    cwd = vim.uv.cwd(),
    bufnr = vim.api.nvim_get_current_buf(),
    opts = {
      hidden = true,
      no_ignore = true,
      follow = true,
    },
  }
  local finder =
    require("dotvim.extra.search-everywhere.finder").universal_finder.new(ctx)

  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values

  local opts = {}

  pickers
    .new(opts, {
      prompt_title = "Search Everywhere",
      sorter = conf.generic_sorter(opts),
      finder = finder,
      previewer = conf.grep_previewer(opts),
    })
    :find()
end

return M
