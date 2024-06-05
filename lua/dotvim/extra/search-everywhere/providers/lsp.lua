---@class dotvim.extra.search_everywhere.lsp
local M = {}

---@type Path
local Path = require("plenary.path")

---@param kind number
---@return string
local function symbol_kind_name(kind)
  return vim.lsp.protocol.SymbolKind[kind] or "Unknown"
end

local displayer = require("telescope.pickers.entry_display").create {
  separator = "  ",
  items = {
    { width = 9, right_justify = true },
    { width = 10 },
    { width = 40 },
    { remaining = true },
  },
}

---Convert a symbol to a list of universal entries.
---
---@param symbol lsp.SymbolInformation | lsp.DocumentSymbol
---@param ctx dotvim.extra.search_everywhere.Context
---@return dotvim.extra.search_everywhere.Entry[]
local function normalize_universal_entry(symbol, ctx)
  if symbol.location then
    symbol = symbol --[[@as lsp.SymbolInformation]]
    local kind = symbol_kind_name(symbol.kind)
    local range = symbol.location.range
    local filename = vim.uri_to_fname(symbol.location.uri)
    ---@type Path
    local file = Path.new(vim.uri_to_fname(symbol.location.uri))
    ---@type dotvim.extra.search_everywhere.Entry[]
    return {
      {
        filename = filename,
        pos = {
          lnum = range.start.line + 1,
          col = range.start.character + 1,
        },
        preview = "FilePos",
        kind = "Symbols",
        columns = {
          kind,
          symbol.name,
          { file:make_relative(ctx.cwd), "Comment" },
        },
        search_key = ("%s%s"):format(kind, symbol.name),
        displayer = displayer,
      },
    }
  elseif symbol.selectionRange then
    symbol = symbol --[[@as lsp.DocumentSymbol]]
    local kind = symbol_kind_name(symbol.kind)
    local filename = vim.api.nvim_buf_get_name(ctx.bufnr)
    ---@diagnostic disable-next-line: param-type-mismatch
    local file = Path.new(filename) --[[@as Path]]
    ---@type dotvim.extra.search_everywhere.Entry[]
    local res = {
      {
        filename = filename,
        pos = {
          lnum = symbol.selectionRange.start.line + 1,
          col = symbol.selectionRange.start.character + 1,
        },
        preview = "FilePos",
        kind = "Symbols",
        columns = {
          kind,
          symbol.name,
          file:make_relative(ctx.cwd),
        },
        search_key = ("%s%s"):format(kind, symbol.name),
      },
    }
    if symbol.children then
      for _, child in ipairs(symbol.children) do
        local normalized = normalize_universal_entry(child, ctx)
        res = vim.list_extend(res, normalized)
      end
    end
    return res
  else
    return {}
  end
end

---@param ctx dotvim.extra.search_everywhere.Context
local function make_lsp_req_callback(ctx, item_callback, complete_callback)
  return function(err, server_result, _, _)
    if err then
      vim.api.nvim_err_writeln(
        "Error when finding workspace symbols: " .. err.message
      )
      return
    end

    server_result = server_result or {}
    for _, symbol in ipairs(server_result) do
      local entries = normalize_universal_entry(symbol, ctx)
      for _, entry in ipairs(entries) do
        item_callback(entry)
      end
    end

    complete_callback()
  end
end

local workspace_symbols = {}

function workspace_symbols.new(ctx)
  local self = setmetatable({
    results = {},
    finished = false,
    cancel = nil,
  }, { __index = workspace_symbols })

  local clients, cancel = vim.lsp.buf_request(
    ctx.bufnr,
    "workspace/symbol",
    { query = "" },
    make_lsp_req_callback(ctx, function(entry)
      self.results[#self.results + 1] = entry
    end, function()
      self.finished = true
      self.cancel = nil
    end)
  )

  if #vim.tbl_keys(clients) > 0 then
    self.cancel = cancel
    self.thread = coroutine.create(function()
      return self:poll()
    end)
  else
    self.finished = true
  end

  return self
end

function workspace_symbols:close()
  if not self.finished and self.cancel then
    self.cancel()
    self.cancel = nil
    self.finished = true
  end
end

function workspace_symbols:poll()
  while true do
    if self.finished then
      return self.results
    end
    coroutine.yield {}
  end
end

M.workspace_symbols = workspace_symbols

return M
