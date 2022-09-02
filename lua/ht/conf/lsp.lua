module('ht.conf.lsp', package.seeall)

-- setup diags
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
    })

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

vim.cmd [[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, border = "rounded"})]]

-- vim: et sw=2 ts=2 fdm=marker

