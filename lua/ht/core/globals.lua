local M = {}

local default_vault_path = {
  "~/Documents/Main",
  "~/Projects/obsidian-data/Main",
}

local function resolve_obsidian_vault()
  if vim.g.obsidian_vault_path then
    return vim.fn.resolve(vim.fn.expand(vim.g.obsidian_vault_path))
  end
  for _, path in ipairs(default_vault_path) do
    local p = vim.fn.resolve(vim.fn.expand(path))
    if vim.fn.isdirectory(p) == 1 then
      return p
    end
  end
  return vim.fn.resolve(vim.fn.expand(default_vault_path[1]))
end

local function resolve_has_obsidian_vault()
  return vim.uv.fs_stat(M.obsidian_vault)
end

M.obsidian_vault = resolve_obsidian_vault()

M.has_obsidian_vault = resolve_has_obsidian_vault()

return M
