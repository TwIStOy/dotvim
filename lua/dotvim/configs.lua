local config_files =
  vim.api.nvim_get_runtime_file("lua/dotvim/configs/*.lua", true)

for _, v in ipairs(config_files) do
  local name = vim.fn.fnamemodify(v, ":t:r")
  require("dotvim.configs." .. name)
end
