---@module "dotvim.configs.globals"

-- set completion engine
vim.g.dotvim_completion_engine = "blink-cmp"

-- check if macos and set curl path
if vim.uv.os_uname().sysname == "Darwin" then
  vim.g.plenary_curl_bin_path = "/opt/homebrew/opt/curl/bin/curl"
end
