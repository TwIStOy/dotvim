local M = {}

local function on_buffer_attach(client, bufnr)
  local navic = require 'nvim-navic'
  local LSP = require('ht.with_plug.lsp')

  -- display diagnostic win on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "CursorMoved", "InsertEnter", "User ShowHover" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })

  ---comment normal map
  ---@param lhs string
  ---@param rhs any
  ---@param desc string
  local nmap = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc, buffer = bufnr })
  end

  nmap('gD', LSP.declaration, 'goto-declaration')

  nmap('gd', LSP.definitions, 'goto-definition')

  nmap('gt', LSP.type_definitions, 'goto-type-definition')

  if LSP.buf_formattable(bufnr) then
    nmap('<leader>fc', LSP.format, 'format-code')
  end

  nmap('K', LSP.show_hover, 'show-hover')

  nmap('gi', LSP.implementations, 'goto-impl')

  nmap('gR', LSP.rename, 'rename-symbol')

  nmap('ga', LSP.code_action, 'code-action')

  nmap('gr', LSP.references, 'inspect-references')

  nmap('[c', LSP.prev_diagnostic, 'previous-diagnostic')

  nmap(']c', LSP.next_diagnostic, 'next-diagnostic')

  nmap('[e', LSP.prev_error_diagnostic, 'previous-error-diagnostic')

  nmap(']e', LSP.next_error_diagnostic, 'next-error-diagnostic')

  if client.name == "clangd" then
    nmap('<leader>fa', function()
      vim.cmd 'ClangdSwitchSourceHeader'
    end, 'clangd-switch-header')
  end

  if client.name == 'rime_ls' then
    nmap('<leader>rs', function()
      vim.lsp.buf.execute_command { command = "rime-ls.sync-user-data" }
    end, 'rime-sync-user-data')

    require'ht.plugrc.lsp.custom.rime'.attach(client, bufnr)
  end

  if client.server_capabilities['documentSymbolProvider'] then
    navic.attach(client, bufnr)
  end
end

M.config = function() -- code to run after plugin loaded
  --- add menus for specific types
  local menu = require 'ht.core.menu'
  local Menu = require 'nui.menu'
  local LSP = require('ht.with_plug.lsp')

  menu:add_section{
    index = 3,
    opts = {
      {
        "LSP",
        keys = 'g',
        children = {
          { "Goto Declaration", callback = LSP.declaration, keys = { 'd' } },
          { 'Goto Definition', callback = LSP.definitions, keys = 'D' },
          { 'Goto Implementation', callback = LSP.implementations, keys = 'i' },
          { 'Inspect References', callback = LSP.references, keys = 'r' },
          { 'Rname', callback = LSP.rename, keys = 'R' },
        },
      },
    },
  }

  menu:add_section{
    index = 4,
    filetype = { 'cpp', 'c' },
    opts = {
      {
        "Symbol Info",
        callback = function()
          vim.cmd 'ClangdSymbolInfo'
        end,
      },
      {
        "Type Hierarchy",
        callback = function()
          vim.cmd 'ClangdTypeHierarchy'
        end,
      },
      {
        "Clangd More",
        children = {
          {
            "View AST",
            callback = function()
              vim.cmd 'ClangdAST'
            end,
          },
          {
            "Memory Usage",
            callback = function()
              vim.cmd 'ClangdMemoryUsage'
            end,
          },
        },
      },
    },
  }

  menu:add_section{
    filetype = 'rust',
    index = 4,
    opts = {
      {
        'Rust',
        keys = 'R',
        children = {
          {
            "Hover Actions",
            callback = function()
              require'rust-tools'.hover_actions.hover_actions()
            end,
          },
          {
            "Open Cargo",
            callback = function()
              require'rust-tools'.open_cargo_toml.open_cargo_toml()
            end,
            keys = 'c',
            desc = 'open project Cargo.toml',
          },
          {
            "Move Item Up",
            callback = function()
              require'rust-tools'.move_item.move_item(true)
            end,
          },
          {
            "Expand Macro",
            callback = function()
              require'rust-tools'.expand_macro.expand_macro()
            end,
            desc = 'expand macros recursively',
            keys = { 'e', 'E' },
          },
          {
            "Parent Module",
            callback = function()
              require'rust-tools'.parent_module.parent_module()
            end,
            keys = 'p',
          },
          {
            "Join Lines",
            callback = function()
              require'rust-tools'.join_lines.join_lines()
            end,
          },
        },
      },
    },
  }

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
      })

  local capabilities = LSP.client_capabilities()

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
        '--background-index-priority=normal',
        '--ranking-model=decision_forest',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
        '--limit-references=100',
        '--limit-results=100',
        '--include-cleaner-stdlib',
        '--malloc-trim',
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
      memory_usage = { border = "rounded" },
      symbol_info = { border = "rounded" },
    },
  }

  require'rust-tools'.setup {
    tools = {
      on_initialized = function()
        vim.notify("rust-analyzer initialize done")
      end,
      inlay_hints = { auto = true },
    },
    server = {
      cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { buildScripts = { enable = true } },
          procMacro = { enable = true },
          check = {
            command = 'clippy',
            extraArgs = { "--all", "--", "-W", "clippy::all" },
          },
          completion = { privateEditable = { enable = true } },
        },
      },
    },
  }

  require'lspconfig'.pyright.setup {
    on_attach = on_buffer_attach,
    capabilities = capabilities,
  }

  require'lspconfig'.lua_ls.setup {
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
            [vim.fn.expand('$HOME/.local/share/nvim/lazy/nui.nvim/lua')] = true,
            [vim.fn.expand('$HOME/.local/share/nvim/lazy/plenary.nvim/lua')] = true,
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

  local rime = require 'ht.plugrc.lsp.custom.rime'
  rime.setup()
  require'lspconfig'.rime_ls.setup {
    cmd = vim.g.rime_ls_cmd,
    init_options = {
      enabled = false,
      shared_data_dir = "/usr/share/rime-data",
      user_data_dir = "~/.local/share/rime-ls",
      log_dir = "~/.local/share/rime-ls/log",
      max_candidates = 9,
      trigger_characters = {},
      schema_trigger_character = "&",
      max_tokens = 4,
      override_server_capabilities = { trigger_characters = {} },
      always_incomplete = true,
    },
    on_attach = on_buffer_attach,
    --- update capabilities???
    capabilities = capabilities,
  }

  require'lspconfig'.tsserver.setup {
    on_attach = on_buffer_attach,
    capabilities = capabilities,
  }

  -- init sourcekit in macos
  if vim.fn.has('macunix') then
    require'lspconfig'.sourcekit.setup {
      filetypes = { 'swift', 'objective-c', 'objective-cpp' },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    }
  end
end

return M
