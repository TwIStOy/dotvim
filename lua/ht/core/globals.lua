local M = {}

local default_vault_path = '~/Dropbox/Obsidian/Main'
function M.obsidian_vault()
  if vim.g.obsidian_vault_path then
    return vim.g.obsidian_vault_path
  end
  return default_vault_path
end

return M
