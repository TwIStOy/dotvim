---@param symbol lsp.DocumentSymbol|lsp.SymbolInformation
---@param bufnr number
---@param depth number
---@return ht.lsp.SymbolInformation[]|nil
local function symbol_to_item(symbol, bufnr, depth)
  if depth == 0 then
    return nil
  end

  if symbol.location then -- SymbolInformation
    local range = symbol.location.range
    local kind = vim.lsp.util._get_symbol_kind_name(symbol.kind)
    return {
      {
        filename = vim.uri_to_fname(symbol.location.uri),
        lnum = range.start.line + 1,
        col = range.start.character + 1,
        kind = kind:lower(),
        text = symbol.name,
        detail = symbol.detail,
      },
    }
  elseif symbol.selectionRange then -- DocumentSymbole type
    local kind = vim.lsp.util._get_symbol_kind_name(symbol.kind)
    local res = {
      {
        filename = vim.api.nvim_buf_get_name(bufnr),
        lnum = symbol.selectionRange.start.line + 1,
        col = symbol.selectionRange.start.character + 1,
        kind = kind:lower(),
        text = symbol.name,
        detail = nil,
      },
    }
    if symbol.children then
      for _, child in ipairs(symbol.children) do
        local item = symbol_to_item(child, bufnr, depth - 1)
        if item then
          res = vim.list_extend(res, item)
        end
      end
    end
    return res
  end
  return nil
end

---@param symbols (lsp.DocumentSymbol|lsp.SymbolInformation)[]
---@param bufnr number?
---@param opts {extra: table?, depth: number?}?
local function symbols_to_items(symbols, bufnr, opts)
  local res = {}
  bufnr = bufnr or 0
  opts = opts or {}
  for _, v in ipairs(symbols) do
    local items = symbol_to_item(v, bufnr, opts.depth or 1)
    if items then
      for _, item in ipairs(items) do
        item = vim.tbl_extend("keep", item, opts.extra or {})
        res[#res + 1] = item
      end
    end
  end
  return res
end

return {
  symbols_to_items = symbols_to_items,
}
