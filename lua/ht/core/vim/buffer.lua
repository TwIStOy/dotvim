---@class VimBuffer
---@field bufnr number
---@field filetype string
---@field filename string|nil
---@field ts_highlights table[]
---@field lsp_servers table[]
local VimBuffer = {}

local api = vim.api

---@param bufnr number|nil
---@return VimBuffer
local function new_buffer(bufnr)
  local filetype = api.nvim_buf_get_option(bufnr, "filetype")
  local filename = api.nvim_buf_get_name(bufnr)
  local highlighters = require("vim.treesitter.highlighter")
  local ts_highlights = { highlighters.active[bufnr] }
  local lsp_servers = vim.lsp.get_active_clients {
    bufnr = bufnr,
  }
  local buffer = {
    bufnr = bufnr,
    filetype = filetype,
    filename = filename,
    ts_highlights = ts_highlights,
    lsp_servers = lsp_servers,
  }
  setmetatable(buffer, { __index = VimBuffer })
  return buffer
end

function VimBuffer:to_cache_key()
  return {
    self.filetype,
    self.filename or "",
    #self.ts_highlights,
    #self.lsp_servers,
  }
end

return new_buffer
