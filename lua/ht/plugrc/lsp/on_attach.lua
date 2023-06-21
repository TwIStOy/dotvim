local function on_buffer_attach(client, bufnr)
  local navic = require("nvim-navic")
  local LSP = require("ht.with_plug.lsp")

  -- display diagnostic win on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          "CursorMoved",
          "InsertEnter",
          "User ShowHover",
          "BufLeave",
          "FocusLost",
        },
        border = "solid",
        source = "if_many",
        prefix = " ",
        focus = false,
        scope = "cursor",
      }
      local bufnr, win = vim.diagnostic.open_float(opts)
      vim.api.nvim_set_option_value(
        "winhl",
        "FloatBorder:NormalFloat",
        { win = win }
      )
    end,
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

  nmap("gr", LSP.references, "inspect-references")

  nmap("[c", LSP.prev_diagnostic, "previous-diagnostic")

  nmap("]c", LSP.next_diagnostic, "next-diagnostic")

  nmap("[e", LSP.prev_error_diagnostic, "previous-error-diagnostic")

  nmap("]e", LSP.next_error_diagnostic, "next-error-diagnostic")

  if client.name == "clangd" then
    nmap("<leader>fa", function()
      vim.cmd("ClangdSwitchSourceHeader")
    end, "clangd-switch-header")
  end

  if client.name == "rime_ls" then
    nmap("<leader>rs", function()
      vim.lsp.buf.execute_command { command = "rime-ls.sync-user-data" }
    end, "rime-sync-user-data")

    require("ht.plugrc.lsp.custom.rime").attach(client, bufnr)
  end

  if client.server_capabilities["documentSymbolProvider"] then
    navic.attach(client, bufnr)
  end
end

return on_buffer_attach
