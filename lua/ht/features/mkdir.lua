local M = {}

local fn = vim.fn

local function mkdir()
  local dir = fn.expand("<afile>:p:h")
  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, "p")
  end
end

function M.register_create_directory_before_save()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      mkdir()
    end,
  })
end

return M
