---@module "dotvim.configs.autocmds"

-- Auto create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Remove line numbers in terminal mode
vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "*",
  callback = function()
    local winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_set_option_value("nu", false, { scope = "local", win = winnr })
    vim.api.nvim_set_option_value("rnu", false, { scope = "local", win = winnr })
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
