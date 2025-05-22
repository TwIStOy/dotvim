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

return M
