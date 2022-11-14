local M = {}

M.core = {
  'neovim/nvim-lspconfig',
  requires = {
    { 'j-hui/fidget.nvim', event = 'BufReadPost' },
    'simrat39/symbols-outline.nvim',
    'p00f/clangd_extensions.nvim',
    'simrat39/rust-tools.nvim',
    'onsails/lspkind-nvim',
    'hrsh7th/nvim-cmp',
    'SmiteshP/nvim-navic',
  },
  opt = true,
  event = 'BufReadPre',
}

local function on_buffer_attach(client, bufnr)
  local mapping = require 'ht.core.mapping'
  local navic = require 'nvim-navic'

  mapping.map({
    keys = { 'g', 'D' },
    action = vim.lsp.buf.declaration,
    desc = 'goto-declaration',
  }, bufnr)
  mapping.map({
    keys = { 'g', 'd' },
    action = vim.lsp.buf.definition,
    desc = 'goto-definition',
  }, bufnr)
  mapping.map(
      { keys = { 'K' }, action = vim.lsp.buf.hover, desc = 'show-hover' }, bufnr)
  mapping.map({
    keys = { 'g', 'i' },
    action = vim.lsp.buf.implementation,
    desc = 'goto-impl',
  }, bufnr)
  mapping.map({
    keys = { 'g', 'R' },
    action = vim.lsp.buf.rename,
    desc = 'rename-symbol',
  }, bufnr)
  mapping.map({
    keys = { 'g', 'a' },
    action = vim.lsp.buf.code_action,
    desc = 'code-action',
  }, bufnr)
  mapping.map({
    keys = { 'g', 'r' },
    action = vim.lsp.buf.references,
    desc = 'inspect-references',
  }, bufnr)

  local dropbox = require 'ht.core.dropbox'

  dropbox.append_buf_context(bufnr, {
    { 'Goto Declaration', 'lua vim.lsp.buf.declaration()' },
    { 'Goto &Definition', 'lua vim.lsp.buf.definition()' },
    { 'Goto &Implementation', 'lua vim.lsp.buf.implementation()' },
    { 'Inspect &References', 'lua vim.lsp.buf.references()' },
    { 'Rname', 'lua vim.lsp.buf.rename()' },
  })

  if client.name == 'clangd' then
    dropbox.append_buf_context(bufnr, {
      { '&Symbol Info(C++)', 'ClangdSymbolInfo' },
      { 'Type &Hierarchy(C++)', 'ClangdTypeHierarchy' },
    })
  end

  if client.server_capabilities['documentSymbolProvider'] then
    navic.attach(client, bufnr)
  end
end

M.config = function() -- code to run after plugin loaded
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
      })

  vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                                                       vim.lsp.handlers
                                                           .signature_help,
                                                       { border = "rounded" })

  require'ht.core.event'.on('CursorHold', {
    pattern = '*',
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
    end,
  })

  require'fidget'.setup { window = { blend = 0 } }
  require'nvim-navic'.setup {
    icons = {
      File = ' ',
      Module = ' ',
      Namespace = ' ',
      Package = ' ',
      Class = ' ',
      Method = ' ',
      Property = ' ',
      Field = ' ',
      Constructor = ' ',
      Enum = ' ',
      Interface = ' ',
      Function = ' ',
      Variable = ' ',
      Constant = ' ',
      String = ' ',
      Number = ' ',
      Boolean = ' ',
      Array = ' ',
      Object = ' ',
      Key = ' ',
      Null = ' ',
      EnumMember = ' ',
      Struct = ' ',
      Event = ' ',
      Operator = ' ',
      TypeParameter = ' ',
    },
  }

  vim.api.nvim_command [[packadd cmp-nvim-lsp]]

  local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- force utf16 only
  capabilities.offsetEncoding = { 'utf-16' }

  require"clangd_extensions".setup {
    server = {
      cmd = {
        vim.g.compiled_llvm_clang_directory .. '/bin/clangd',
        '--clang-tidy',
        '--background-index',
        '--ranking-model=decision_forest',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
        '--limit-references=100',
        '--limit-results=100',
        -- '--pch-storage=disk',
        -- '--use-dirty-headers',
        '--include-cleaner-stdlib',
        '-j=20',
      },
      on_attach = on_buffer_attach,
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
      ast = {
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
        kind_icons = {
          Compound = "🄲",
          Recovery = "🅁",
          TranslationUnit = "🅄",
          PackExpansion = "🄿",
          TemplateTypeParm = "🅃",
          TemplateTemplateParm = "🅃",
          TemplateParamObject = "🅃",
        },
      },
    },
  }

  require'rust-tools'.setup {
    server = {
      cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    },
  }

  require'lspconfig'.pyright.setup {
    on_attach = on_buffer_attach,
    capabilities = capabilities,
  }

  require'lspconfig'.sumneko_lua.setup {
    cmd = vim.g.lua_language_server_cmd,
    on_attach = on_buffer_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
        diagnostics = { globals = { 'vim' } },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            [vim.fn.expand('$HOME/.dotvim/lua')] = true,
          },
        },
      },
    },
  }

  require'lspconfig'.cmake.setup {
    on_attach = on_buffer_attach,
    capabilities = capabilities,
    initializationOptions = { buildDirectory = 'build' },
  }

  if vim.fn.has('macunix') then
    require'lspconfig'.sourcekit.setup {
      filetypes = { 'swift', 'objective-c', 'objective-cpp' },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    }
  end
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'
  mapping.map({
    keys = { '[', 'c' },
    action = function()
      vim.diagnostic.goto_prev()
    end,
    desc = 'previous-diagnostic',
  })
  mapping.map({
    keys = { ']', 'c' },
    action = function()
      vim.diagnostic.goto_next()
    end,
    desc = 'next-diagnostic',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

