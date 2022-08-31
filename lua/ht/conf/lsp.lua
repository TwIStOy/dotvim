module('ht.conf.lsp', package.seeall)

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol
                                                                   .make_client_capabilities())

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '[c', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', ']c', '<cmd>lua vim.diagnostic.goto_next()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', 'tt', '<cmd>TroubleToggle<CR>', opts)

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                              '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                              '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                              '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                              '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR',
                              '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga',
                              '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                              '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  local dd = require 'ht.core.dropdown'
  dd.AddBufContext(bufnr, {
    { 'Goto Declaration', 'lua vim.lsp.buf.declaration()' },
    { 'Goto &Definition', 'lua vim.lsp.buf.definition()' },
    { 'Goto &Implementation', 'lua vim.lsp.buf.implementation()' },
    { 'Inspect &References', 'lua vim.lsp.buf.references()' },
    { 'Rname', 'lua vim.lsp.buf.rename()' },
  })

  if client.name == 'clangd' then
    dd.AddBufContext(bufnr, {
      { '&Symbol Info(C++)', 'ClangdSymbolInfo' },
      { 'Type &Hierarchy(C++)', 'ClangdTypeHierarchy' },
    })
  end
end

require"clangd_extensions".setup {
  server = {
    cmd = {
      vim.g.compiled_llvm_clang_directory .. '/bin/clangd',
      -- '--clang-tidy',
      '--background-index',
      '--ranking-model=decision_forest',
      '--completion-style=detailed',
      '--header-insertion=iwyu',
      '--limit-references=100',
      '--limit-results=100',
      '--pch-storage=disk',
      '--use-dirty-headers',
      '--include-cleaner-stdlib',
      '-j=20',
    },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  extensions = {
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
      only_current_line = false,
      only_current_line_autocmd = "CursorHold",
      show_parameter_hints = true,
      show_variable_name = false,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
      highlight = "Comment",
    },
  },
}

require'rust-tools'.setup {
  server = { on_attach = on_attach, capabilities = capabilities },
}

require'lspconfig'.sumneko_lua.setup {
  cmd = {
    '/home/hawtian/project/lua-language-server/bin/lua-language-server',
    '-E',
    '/home/hawtian/project/lua-language-server/bin/main.lua',
  },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}

-- setup diags
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
    })

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

vim.cmd [[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, border = "rounded"})]]

-- vim: et sw=2 ts=2 fdm=marker

