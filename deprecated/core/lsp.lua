---@class dotvim.core.lsp
local M = {}

---@param callback fun(client?: vim.lsp.Client, buffer: number): boolean?
function M.on_lsp_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      ---@type vim.lsp.Client?
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      return callback(client, buffer)
    end,
  })
end

---Try to get the root of the current LSP client
---@param bufnr? number
---@return string?, string? -- root_dir,client_name
function M.get_lsp_root(bufnr)
  bufnr = vim.F.if_nil(bufnr, 0)
  local buf_ft = vim.api.nvim_get_option_value("filetype", {
    buf = bufnr,
  })
  ---@type vim.lsp.Client[]
  local clients = vim.lsp.get_clients {
    bufnr = bufnr,
  }
  if #clients == 0 then
    return nil
  end

  for _, value in ipairs(clients) do
    local filetypes = vim.F.if_nil(vim.tbl_get(value.config, "filetypes"), {})
    if vim.tbl_contains(filetypes, buf_ft) then
      return value.config.root_dir, value.name
    end
  end

  return nil
end

return M
