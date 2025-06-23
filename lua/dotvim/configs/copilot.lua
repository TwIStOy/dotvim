---@module 'dotvim.configs.copilot'

-- Copilot status command keymaps
vim.keymap.set("n", "<leader>cs", "<cmd>Copilot status<cr>", { desc = "copilot-status" })
vim.keymap.set("n", "<leader>ca", "<cmd>Copilot auth<cr>", { desc = "copilot-auth" })
vim.keymap.set("n", "<leader>cp", "<cmd>Copilot panel<cr>", { desc = "copilot-panel" })
