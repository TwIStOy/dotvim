local M = {}

M.on_attach = function(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, buffer)
    end,
  })
end

return M
