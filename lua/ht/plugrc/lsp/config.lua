local M = {}

local function get_client_capabilities()
  local cmp_lsp = require 'cmp_nvim_lsp'
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = cmp_lsp.default_capabilities(default_capabilities)
  return capabilities
end

local function is_null_ls_formatting_enabled(bufnr)
  local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local generators = require("null-ls.generators")
  local methods = require("null-ls.methods")
  local available_generators = generators.get_available(file_type,
                                                        methods.internal
                                                            .FORMATTING)
  return #available_generators > 0
end

local function on_buffer_attach(client, bufnr)
  local navic = require 'nvim-navic'

  -- display diagnostic win on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          "BufLeave",
          "CursorMoved",
          "InsertEnter",
          "FocusLost",
          "User ShowHover",
        },
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

  nmap('gD', vim.lsp.buf.declaration, 'goto-declaration')

  nmap('gd', function()
    require'telescope.builtin'.lsp_definitions {}
  end, 'goto-definition')

  nmap('gt', function()
    require'telescope.builtin'.lsp_type_definitions {}
  end, 'goto-type-definition')

  if is_null_ls_formatting_enabled(bufnr) then
    nmap('<leader>fc', function()
      vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(c)
          return c.name == "null-ls"
        end,
      })
    end, 'format-code')
  end

  nmap('K', function()
    vim.o.eventignore = 'CursorHold'
    vim.cmd([[doautocmd User ShowHover]])
    vim.lsp.buf.hover()
    vim.cmd([[autocmd CursorMoved <buffer> ++once set eventignore=""]])
  end, 'show-hover')

  nmap('gi', function()
    require'telescope.builtin'.lsp_implementations {}
  end, 'goto-impl')

  nmap('gR', vim.lsp.buf.rename, 'rename-symbol')

  nmap('ga', vim.lsp.buf.code_action, 'code-action')

  nmap('gr', function()
    require'telescope.builtin'.lsp_references {}
  end, 'inspect-references')

  nmap('[c', vim.diagnostic.goto_prev, 'previous-diagnostic')

  nmap(']c', vim.diagnostic.goto_next, 'next-diagnostic')

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

  menu:append_section("*", {
    Menu.item("LSP", {
      items = {
        Menu.item("Goto Declaration", {
          action = function()
            vim.lsp.buf.declaration()
          end,
        }),
        Menu.item('Goto Definition', {
          action = function()
            require'telescope.builtin'.lsp_definitions {}
          end,
        }),
        Menu.item('Goto Implementation', {
          action = function()
            require'telescope.builtin'.lsp_implementations {}
          end,
        }),
        Menu.item('Inspect References', {
          action = function()
            require'telescope.builtin'.lsp_references {}
          end,
        }),
        Menu.item('Rname', {
          action = function()
            vim.lsp.buf.rename()
          end,
        }),
      },
    }),
  }, 3)

  menu:append_section("cpp", {
    Menu.item("Symbol Info", {
      action = function()
        vim.cmd 'ClangdSymbolInfo'
      end,
    }),
    Menu.item("Type Hierarchy", {
      action = function()
        vim.cmd 'ClangdTypeHierarchy'
      end,
    }),
    Menu.item("Clangd More", {
      items = {
        Menu.item("View AST", {
          action = function()
            vim.cmd 'ClangdAST'
          end,
        }),
        Menu.item("Memory Usage", {
          action = function()
            vim.cmd 'ClangdMemoryUsage'
          end,
        }),
      },
    }),
  }, 4)

  menu:append_section("rust", {
    Menu.item("Rust-tools", {
      items = {
        Menu.item("Hover Actions", {
          action = function()
            require'rust-tools'.hover_actions.hover_actions()
          end,
        }),
        Menu.item("Open Cargo", {
          action = function()
            require'rust-tools'.open_cargo_toml.open_cargo_toml()
          end,
          desc = 'open project Cargo.toml',
        }),
        Menu.item("Move Item Up", {
          action = function()
            require'rust-tools'.move_item.move_item(true)
          end,
        }),
        Menu.item("Expand Macro", {
          action = function()
            require'rust-tools'.expand_macro.expand_macro()
          end,
          desc = 'expand macros recursively',
        }),
        Menu.item("Parent Module", {
          action = function()
            require'rust-tools'.parent_module.parent_module()
          end,
        }),
        Menu.item("Join Lines", {
          action = function()
            require'rust-tools'.join_lines.join_lines()
          end,
        }),
      },
    }),
  }, 4)

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
      })

  local capabilities = get_client_capabilities()

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
      inlay_hints = { auto = false },
    },
    server = {
      cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
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

  -- init sourcekip in macos
  if vim.fn.has('macunix') then
    require'lspconfig'.sourcekit.setup {
      filetypes = { 'swift', 'objective-c', 'objective-cpp' },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    }
  end
end

return M
