---@class VimBuffer
---@field bufnr number
---@field filetype string
---@field filename string|nil
---@field ts_highlights table[]
---@field lsp_servers lsp.Client[]
local VimBuffer = {}

local api = vim.api

---@param bufnr number|nil
---@return VimBuffer
local function new_buffer(bufnr)
  local filetype = api.nvim_buf_get_option(bufnr, "filetype")
  local filename = api.nvim_buf_get_name(bufnr)
  local highlighters = require("vim.treesitter.highlighter")
  local ts_highlights = { highlighters.active[bufnr] }
  ---@type lsp.Client[]
  local lsp_servers = vim.lsp.get_clients {
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
  local s = {
    self.filetype,
    self.filename or "",
    #self.ts_highlights,
    #self.lsp_servers,
  }
  for _, server in ipairs(self.lsp_servers) do
    s[#s + 1] = server.name
  end
  return s
end

local default_exclude_lsp = {
  ["null-ls"] = true,
  copilot = true,
}

function VimBuffer:lsp_attached()
  local count = 0
  for _, server in ipairs(self.lsp_servers) do
    if
      default_exclude_lsp[server.name] == nil
      or not default_exclude_lsp[server.name]
    then
      count = count + 1
    end
  end
  return count > 0
end

return new_buffer
