-- Copilot status command keymaps
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>Copilot status<cr>",
  { desc = "copilot-status" }
)
vim.keymap.set(
  "n",
  "<leader>ca",
  "<cmd>Copilot auth<cr>",
  { desc = "copilot-auth" }
)
vim.keymap.set(
  "n",
  "<leader>cp",
  "<cmd>Copilot panel<cr>",
  { desc = "copilot-panel" }
)

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.concelllevel = 0
    vim.b.blink_pairs = false
  end,
})
