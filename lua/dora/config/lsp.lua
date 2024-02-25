---@class dora.config.lsp.BackendConfig
---@field definitions 'native' | 'telescope' | 'glance'

local function declaration()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.revealDeclaration")
  else
    vim.lsp.buf.declaration()
  end
end

local function definitions()
  local config = require("dora.config").config
  local backend = config.lsp.definitions or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.revealDefinition")
  elseif backend == "native" then
    vim.lsp.buf.definition()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_definitions()
  elseif backend == "glance" then
    require("glance").open("definitions")
  else
    vim.notify(
      "Unknown backend for definitions: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

local function type_definitions()
  local config = require("dora.config").config
  local backend = config.lsp.type_definitions or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.goToTypeDefinition")
  elseif backend == "native" then
    vim.lsp.buf.type_definition()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_type_definitions()
  elseif backend == "glance" then
    require("glance").open("type_definitions")
  else
    vim.notify(
      "Unknown backend for type definitions: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

local function implementations()
  local config = require("dora.config").config
  local backend = config.lsp.implementations or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.goToImplementation")
  elseif backend == "native" then
    vim.lsp.buf.implementation()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_implementations()
  elseif backend == "glance" then
    require("glance").open("implementations")
  else
    vim.notify(
      "Unknown backend for implementations: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

local function references()
  local config = require("dora.config").config
  local backend = config.lsp.implementations or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("references-view.findReferences")
  elseif backend == "native" then
    vim.lsp.buf.references()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_references()
  elseif backend == "glance" then
    require("glance").open("references")
  else
    vim.notify(
      "Unknown backend for references: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

local function code_action()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.quickFix")
  else
    vim.cmd("Lspsaga code_action")
  end
end

-- local function next_diagnostic()
--   if vim.g.vscode then
--     require("vscode-neovim").call("editor.action.marker.nextInFiles")
--   else
--     vim.lsp.diagnostic.goto_next()
--   end
-- end



return {
  declaration = declaration,
  definitions = definitions,
  type_definitions = type_definitions,
  implementations = implementations,
  references = references,
}
