---@class dotvim.core.vim
local M = {}

local uncount_lsp = {
  ["null-ls"] = true,
  ["copilot"] = true,
  ["none-ls"] = true,
}

---@class dotvim.vim.BufferWrapper Buffer relative properties
---@field bufnr number
---@field filetype string
---@field full_file_name string
---@field lsp_servers vim.lsp.Client[]
---@field ts_highlighter vim.treesitter.highlighter[]
local Buffer = {}

---@return string
function Buffer:as_cache_key()
  local arr = {
    self.filetype,
    self.full_file_name,
    #self.lsp_servers,
    #self.ts_highlighter,
  }
  for _, v in ipairs(self.lsp_servers) do
    arr[#arr + 1] = v.name
  end
  return vim.json.encode(arr)
end

---Returns the number of language servers attached to the buffer except
---`null-ls`, `copilot` and `none-ls`.
---@return number
function Buffer:lang_server_count()
  local count = 0
  for _, v in ipairs(self.lsp_servers) do
    if not uncount_lsp[v.name] then
      count = count + 1
    end
  end
  return count
end

---@param bufnr number
---@return dotvim.vim.BufferWrapper
function M.wrap_buffer(bufnr)
  return setmetatable({
    bufnr = bufnr,
    filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
    full_file_name = vim.api.nvim_buf_get_name(bufnr),
    lsp_servers = vim.lsp.get_clients {
      bufnr = bufnr,
    },
    ts_highlighter = { vim.treesitter.highlighter.active[bufnr] },
  }, {
    __index = Buffer,
  })
end

return M
