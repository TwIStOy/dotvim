---@module 'dotvim.configs.diagnostics'

local Icons = require("dotvim.commons.icon")

-- Configure diagnostics with signs in signcolumn
vim.diagnostic.config({
    signs = {
        text = {
        [vim.diagnostic.severity.ERROR] = Icons.icon("DiagnosticError"),
        [vim.diagnostic.severity.WARN] = Icons.icon("DiagnosticWarn"),
        [vim.diagnostic.severity.INFO] = Icons.icon("DiagnosticInfo"),
        [vim.diagnostic.severity.HINT] = Icons.icon("DiagnosticHint"),
        },
    },
    severity_sort = true,
    virtual_text = false,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})