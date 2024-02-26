return function()
  local lib = require("dora.lib")

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
      lib.cache.call_once(function()
        require("dora.config.autocmd.override-fswatch")
      end)

      local lsp = require("dora.config.lsp")

      -- register diagnostic handlers
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = 0,
        callback = lsp.open_diagnostic,
      })
    end,
  })
end
