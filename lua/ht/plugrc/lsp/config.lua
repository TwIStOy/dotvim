local M = {}

local function get_client_capabilities()
  local cmp_lsp = require 'cmp_nvim_lsp'
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = cmp_lsp.default_capabilities(default_capabilities)
  return capabilities
end

local current_diagnostic_win = nil

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
    action = function()
      require'telescope.builtin'.lsp_definitions {}
    end,
    desc = 'goto-definition',
  }, bufnr)
  mapping.map({
    keys = { 'g', 't' },
    action = function()
      require'telescope.builtin'.lsp_type_definitions {}
    end,
    desc = 'goto-definition',
  }, bufnr)
  mapping.map({
    keys = { 'K' },
    action = function()
      if current_diagnostic_win ~= nil then
        vim.api.nvim_win_close(current_diagnostic_win, true)
        vim.api.nvim_command('redraw')
        current_diagnostic_win = nil
      end

      vim.o.eventignore = 'CursorHold'
      vim.lsp.buf.hover()
      vim.cmd([[autocmd CursorMoved <buffer> ++once set eventignore=""]])
    end,
    desc = 'show-hover',
  }, bufnr)
  mapping.map({
    keys = { 'g', 'i' },
    action = function()
      require'telescope.builtin'.lsp_implementations {}
    end,
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
    action = function()
      require'telescope.builtin'.lsp_references {}
    end,
    desc = 'inspect-references',
  }, bufnr)
  mapping.map({
    keys = { '[', 'c' },
    action = function()
      vim.diagnostic.goto_prev()
    end,
    desc = 'previous-diagnostic',
  }, bufnr)
  mapping.map({
    keys = { ']', 'c' },
    action = function()
      vim.diagnostic.goto_next()
    end,
    desc = 'next-diagnostic',
  }, bufnr)

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

  --[[
  require("mason").setup {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    pip = { install_args = { '-i', 'https://pypi.tuna.tsinghua.edu.cn/simple' } },

  }
  --]]

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
      })

  require'ht.core.event'.on('CursorHold', {
    pattern = '*',
    callback = function()
      local buf, win = vim.diagnostic.open_float(nil, {
        focus = false,
        border = "rounded",
      })
      current_diagnostic_win = win
    end,
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
    server = {
      cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = 'clippy',
            extraArgs = { "--all", "--", "-W", "clippy::all" },
          },
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

