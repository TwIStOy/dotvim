---@module "dotvim.configs.keymaps"

-- Disable arrow keys
vim.api.nvim_set_keymap("", "<Left>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Right>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Up>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Down>", "<Nop>", {})

-- Basic file operations
vim.keymap.set("n", "<leader>fs", "<cmd>update<CR>", { desc = "save" })

-- Clear search highlighting
vim.keymap.set("n", "<M-n>", "<cmd>nohl<CR>", { desc = "nohl" })

-- Quit commands
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "quit-all" })

-- Window management (non-vscode)
if not vim.g.vscode then
  vim.keymap.set("n", "<leader>wv", "<cmd>wincmd v<CR>", { desc = "split-window-vertical" })
  vim.keymap.set("n", "<leader>w-", "<cmd>wincmd s<CR>", { desc = "split-window-horizontal" })
  vim.keymap.set("n", "<leader>w=", "<cmd>wincmd =<CR>", { desc = "balance-window" })
  vim.keymap.set("n", "<leader>wr", "<cmd>wincmd r<CR>", { desc = "rotate-window-rightwards" })
  vim.keymap.set("n", "<leader>wx", "<cmd>wincmd x<CR>", { desc = "exchange-window-with-next" })
end
