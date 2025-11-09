---@module 'dotvim.commons.lsp'
local M = {}

---Register a callback on LspAttach event.
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

---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method.ClientToServer
---@param bufnr? integer
function M.client_supports(client, method, bufnr)
  if vim.fn.has("nvim-0.11") == 1 then
    return client:supports_method(method, { bufnr = bufnr })
  else
    return client.supports_method(method)
  end
end

return M
