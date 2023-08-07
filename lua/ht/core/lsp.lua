local UtilTbl = require("ht.utils.table")

---@param symbol lsp.DocumentSymbol|lsp.SymbolInformation
---@return ht.lsp.SymbolInformation?
local function symbol_to_item(symbol, bufnr)
  if symbol.location then -- SymbolInformation
    local range = symbol.location.range
    local kind = vim.lsp.util._get_symbol_kind_name(symbol.kind)
    return {
      filename = vim.uri_to_fname(symbol.location.uri),
      lnum = range.start.line + 1,
      col = range.start.character + 1,
      kind = kind,
      text = symbol.name,
      detail = symbol.detail,
    }
  elseif symbol.selectionRange then -- DocumentSymbole type
    local kind = vim.lsp.util._get_symbol_kind_name(symbol.kind)
    return {
      -- bufnr = _bufnr,
      filename = vim.api.nvim_buf_get_name(bufnr),
      lnum = symbol.selectionRange.start.line + 1,
      col = symbol.selectionRange.start.character + 1,
      kind = kind,
      text = symbol.name,
      detail = nil,
    }
  end
  return nil
end

---@param symbols (lsp.DocumentSymbol|lsp.SymbolInformation)[]
---@param bufnr number?
---@param extra table?
local function symbols_to_items(symbols, bufnr, extra)
  local res = {}
  bufnr = bufnr or 0
  extra = extra or {}
  for _, v in ipairs(symbols) do
    local item = symbol_to_item(v, bufnr)
    if item then
      item = vim.tbl_extend("keep", item, extra)
      res[#res + 1] = item
    end
  end
  return res
end

return {
  utils = {
    symbols_to_items = symbols_to_items,
  },
}
