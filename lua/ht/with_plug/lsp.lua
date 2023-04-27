local M = {}

local A = vim.api
local lsp_hover_ns = A.nvim_create_namespace('ht_lsp_hover')

function M.declaration()
  vim.lsp.buf.declaration()
end

function M.definitions()
  require'glance'.open('definitions')
end

function M.type_definitions()
  require'glance'.open('type_definitions')
end

function M.implementations()
  require'glance'.open('implementations')
end

function M.references()
  require'glance'.open('references')
end

function M.rename(new_name, options)
  options = options or {}
  local filter = function(client)
    return not vim.tbl_contains({ "null-ls", "copilot" }, client.name)
  end
  options.filter = options.filter or filter
  vim.lsp.buf.rename(new_name, options)
end

function M.code_action()
  vim.cmd 'Lspsaga code_action'
end

function M.show_hover()
  vim.o.eventignore = "CursorHold"
  vim.cmd('doautocmd User ShowHover')
  vim.lsp.buf.hover()
  A.nvim_create_autocmd({ 'CursorMoved' },
                        {
    group = lsp_hover_ns,
    buffer = 0,
    command = 'set eventignore=""',
    once = true,
  })
end

function M.prev_diagnostic()
  vim.diagnostic.goto_prev { wrap = false }
end

function M.next_diagnostic()
  vim.diagnostic.goto_next { wrap = false }
end

function M.prev_error_diagnostic()
  vim.diagnostic.goto_prev {
    wrap = false,
    severity = vim.diagnotic.severity.ERROR,
  }
end

function M.next_error_diagnostic()
  vim.diagnostic.goto_next {
    wrap = false,
    severity = vim.diagnotic.severity.ERROR,
  }
end

function M.client_capabilities()
  local cmp_lsp = require 'cmp_nvim_lsp'
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = cmp_lsp.default_capabilities(default_capabilities)
  return capabilities
end

function M.buf_formattable(bufnr)
  local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local generators = require("null-ls.generators")
  local methods = require("null-ls.methods")
  local available_generators = generators.get_available(file_type,
                                                        methods.internal
                                                            .FORMATTING)
  return #available_generators > 0
end

function M.format()
  vim.lsp.buf.format({
    filter = function(c)
      return c.name == "null-ls"
    end,
  })
end

return M
