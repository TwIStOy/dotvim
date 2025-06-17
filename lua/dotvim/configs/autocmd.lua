---@module 'dotvim.configs.autocmd'

-- General autocmd configurations

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("dotvim.auto_mkdir", { clear = true }),
  pattern = "*",
  callback = function()
    local file_path = vim.fn.expand("<afile>")
    if file_path == "" then
      return
    end
    
    local dir = vim.fn.fnamemodify(file_path, ":h")
    if dir ~= "" and not vim.fn.isdirectory(dir) then
      vim.fn.mkdir(dir, "p")
    end
  end,
  desc = "auto-create-dir-on-save",
})
