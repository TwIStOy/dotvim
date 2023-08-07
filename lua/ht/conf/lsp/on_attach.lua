local Const = require("ht.core.const")

local function on_buffer_attach(client, bufnr)
  local navic = require("nvim-navic")
  local LSP = require("ht.with_plug.lsp")

  -- display diagnostic win on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = LSP.open_diagnostic,
  })

  ---comment normal map
  ---@param lhs string
  ---@param rhs any
  ---@param desc string
  local nmap = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
  end

  nmap("gD", LSP.declaration, "goto-declaration")

  nmap("gd", LSP.definitions, "goto-definition")

  nmap("gt", LSP.type_definitions, "goto-type-definition")

  nmap("<leader>fc", function()
    LSP.format(bufnr)
  end, "format-code")

  nmap("K", LSP.show_hover, "show-hover")

  nmap("gi", LSP.implementations, "goto-impl")

  nmap("gR", LSP.rename, "rename-symbol")

  nmap("ga", LSP.code_action, "code-action")

  if not Const.is_gui then
    nmap("<Char-0xAB>", LSP.code_action, "code-action")
  else
    nmap("<D-.>", LSP.code_action, "code-action")
  end

  nmap("gr", LSP.references, "inspect-references")

  nmap("[c", LSP.prev_diagnostic, "previous-diagnostic")

  nmap("]c", LSP.next_diagnostic, "next-diagnostic")

  nmap("[e", LSP.prev_error_diagnostic, "previous-error-diagnostic")

  nmap("]e", LSP.next_error_diagnostic, "next-error-diagnostic")

  if not Const.is_gui then
    nmap("<Char-0xAC>", function()
      LSP.top_level_workspace_and_document_symbols()
    end, "doc-symbols-test")
  else
    nmap("<D-k>", function()
      LSP.top_level_workspace_and_document_symbols()
    end, "doc-symbols-test")
  end

  if client.server_capabilities["documentSymbolProvider"] then
    navic.attach(client, bufnr)
  end
end

return on_buffer_attach
