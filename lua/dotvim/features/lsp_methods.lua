---@module 'dotvim.features.lsp_methods'

local M = {}

---Navigate to declaration
function M.declaration()
  vim.lsp.buf.declaration()
end

---Navigate to definitions
function M.definitions()
  if vim.g.vscode then
    vim.lsp.buf.definition()
  else
    require("glance").open("definitions")
  end
end

---Navigate to type definitions
function M.type_definitions()
  if vim.g.vscode then
    vim.lsp.buf.type_definition()
  else
    require("glance").open("type_definitions")
  end
end

---Navigate to implementations
function M.implementations()
  if vim.g.vscode then
    vim.lsp.buf.implementation()
  else
    require("glance").open("implementations")
  end
end

---Show references
function M.references()
  if vim.g.vscode then
    vim.lsp.buf.references()
  else
    require("glance").open("references")
  end
end

---Trigger code action
function M.code_action()
  vim.lsp.buf.code_action()
end

return M
