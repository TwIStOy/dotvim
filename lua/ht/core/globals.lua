local M = {}

local default_vault_path = '~/Dropbox/Obsidian/Main'

local function resolve_obsidian_vault()
  if vim.g.obsidian_vault_path then
    return vim.fn.resolve(vim.fn.expand(vim.g.obsidian_vault_path))
  end
  return vim.fn.resolve(vim.fn.expand(default_vault_path))
end

local function resolve_has_obsidian_vault()
  return vim.loop.fs_stat(M.obsidian_vault)
end

M.obsidian_vault = resolve_obsidian_vault()

M.has_obsidian_vault = resolve_has_obsidian_vault()

return M
