local features = require("dotvim.features")

-- LSP method keybindings
vim.keymap.set("n", "gD", features.lsp_methods.declaration, { desc = "goto-declaration" })
vim.keymap.set("n", "gd", features.lsp_methods.definitions, { desc = "goto-definitions" })
vim.keymap.set("n", "gt", features.lsp_methods.type_definitions, { desc = "goto-type-definitions" })
vim.keymap.set("n", "gi", features.lsp_methods.implementations, { desc = "goto-implementations" })
vim.keymap.set("n", "gr", features.lsp_methods.references, { desc = "goto-references" })
vim.keymap.set("n", "ga", features.lsp_methods.code_action, { desc = "code-action" })
vim.keymap.set("n", "gR", features.lsp_methods.rename, { desc = "rename-symbol" })
vim.keymap.set("n", "<leader>oi", features.lsp_methods.organize_imports, { desc = "organize-imports" })
vim.keymap.set("n", "K", features.lsp_methods.show_hover, { desc = "show-hover" })
vim.keymap.set("n", "<leader>ss", features.lsp_methods.document_symbols, { desc = "document-symbols" })
vim.keymap.set("n", "<leader>sw", features.lsp_methods.workspace_symbols, { desc = "workspace-symbols" })

-- Diagnostic navigation keybindings
vim.keymap.set("n", "]c", features.lsp_methods.next_diagnostic, { desc = "goto-next-error" })
vim.keymap.set("n", "[c", features.lsp_methods.prev_diagnostic, { desc = "goto-prev-error" })
vim.keymap.set("n", "]d", features.lsp_methods.next_diagnostic_all, { desc = "goto-next-diagnostic" })
vim.keymap.set("n", "[d", features.lsp_methods.prev_diagnostic_all, { desc = "goto-prev-diagnostic" })
