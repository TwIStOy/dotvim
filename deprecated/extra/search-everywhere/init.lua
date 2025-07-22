---@class dotvim.extra.search_everywhere
local M = {}

---@class dotvim.extra.search_everywhere.Entry
---@field filename? string
---@field pos? { lnum: integer, col: integer }
---@field preview "FilePos" | 'FileLine' | 'File' | "None"
---@field kind "Symbols" | "Files" | 'Text' | 'Action'
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

---@type dotvim.utils
local Utils = require("dotvim.utils")

function M.open_telescope()
  local bufnr = vim.api.nvim_get_current_buf()
  local project_cwd =
    ---@diagnostic disable-next-line: undefined-field
    vim.F.if_nil(
      Utils.vim.buf_get_var(bufnr, "_dotvim_project_cwd"),
      ---@diagnostic disable-next-line: undefined-field
      vim.uv.cwd()
    )
  local project_no_ignore = vim.F.if_nil(
    Utils.vim.buf_get_var(bufnr, "_dotvim_project_no_ignore"),
    false
  )

  local ctx = {
    cwd = project_cwd,
    bufnr = bufnr,
    opts = {
      hidden = false,
      no_ignore = project_no_ignore,
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
