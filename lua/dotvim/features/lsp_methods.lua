---@module 'dotvim.features.lsp_methods'
local M = {}

---Navigate to declaration
function M.declaration()
  -- vscode-neovim provides builtin vim.lsp.buf overrides
  vim.lsp.buf.declaration()
end

---Navigate to definitions
function M.definitions()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.definition()
  else
    require("glance").open("definitions")
  end
end

---Navigate to type definitions
function M.type_definitions()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.type_definition()
  else
    require("glance").open("type_definitions")
  end
end

---Navigate to implementations
function M.implementations()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.implementation()
  else
    require("glance").open("implementations")
  end
end

---Show references
function M.references()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.references()
  else
    require("glance").open("references")
  end
end

---Trigger code action
function M.code_action()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.code_action()
  else
    require("tiny-code-action").code_action()
  end
end

---Navigate to next diagnostic
function M.next_diagnostic()
  if vim.g.vscode then
    -- VSCode doesn't have built-in error-only navigation, so we use the general marker command
    -- This navigates through all diagnostics, not just errors
    require("vscode").action("editor.action.marker.nextInFiles")
  else
    vim.diagnostic.jump {
      count = 1,
      wrap = false,
      float = false,
      severity = vim.diagnostic.severity.ERROR,
    }
  end
end

---Navigate to previous diagnostic
function M.prev_diagnostic()
  if vim.g.vscode then
    -- VSCode doesn't have built-in error-only navigation, so we use the general marker command
    -- This navigates through all diagnostics, not just errors
    require("vscode").action("editor.action.marker.prevInFiles")
  else
    vim.diagnostic.jump {
      count = -1,
      wrap = false,
      float = false,
      severity = vim.diagnostic.severity.ERROR,
    }
  end
end

---Navigate to next diagnostic (all severities)
function M.next_diagnostic_all()
  if vim.g.vscode then
    require("vscode").action("editor.action.marker.nextInFiles")
  else
    vim.diagnostic.jump {
      count = 1,
      wrap = false,
      float = false,
    }
  end
end

---Navigate to previous diagnostic (all severities)
function M.prev_diagnostic_all()
  if vim.g.vscode then
    require("vscode").action("editor.action.marker.prevInFiles")
  else
    vim.diagnostic.jump {
      count = -1,
      wrap = false,
      float = false,
    }
  end
end

---Show hover information
function M.show_hover()
  if vim.g.vscode then
    -- VSCode hover action
    require("vscode").action("editor.action.showHover")
  else
    -- Native neovim hover with solid border
    vim.lsp.buf.hover {
      border = "solid",
    }
  end
end

---Rename symbol
function M.rename()
  if vim.g.vscode then
    -- VSCode rename action
    require("vscode").action("editor.action.rename")
  else
    -- Native neovim rename
    vim.lsp.buf.rename()
  end
end

---Organize imports
function M.organize_imports()
  if vim.g.vscode then
    -- VSCode organize imports action
    require("vscode").action("editor.action.organizeImports")
  else
    -- Native neovim organize imports using generic LSP code action
    vim.lsp.buf.code_action {
      context = {
        only = { "source.organizeImports" },
      },
      apply = true,
    }
  end
end

return M
