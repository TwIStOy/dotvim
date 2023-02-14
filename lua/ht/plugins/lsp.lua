local M = {}

M.core = {
  'neovim/nvim-lspconfig',
  requires = {
    --[[
    {
      'j-hui/fidget.nvim',
      event = 'BufReadPost',
      config = function()
        require'fidget'.setup { window = { blend = 0 } }
      end,
    },
    --]]
    {
      'simrat39/symbols-outline.nvim',
      cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen', 'SymbolsOutlineClose' },
    },
    { 'p00f/clangd_extensions.nvim', module = 'clangd_extensions' },
    { 'simrat39/rust-tools.nvim', opt = true },
    { 'SmiteshP/nvim-navic', opt = true },
    'onsails/lspkind.nvim',
    'hrsh7th/nvim-cmp',
    'MunifTanjim/nui.nvim',
    -- 'williamboman/mason.nvim',
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
            vim.lsp.buf.definition()
          end,
        }),
        Menu.item('Goto Implementation', {
          action = function()
            vim.lsp.buf.implementation()
          end,
        }),
        Menu.item('Inspect References', {
          action = function()
            vim.lsp.buf.references()
          end,
        }),
        Menu.item('Rname', {
          action = function()
            vim.lsp.buf.rename()
          end,
        }),
      },
    }),
  })

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
  })

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
  })

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

  --[[
  vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                                                       vim.lsp.handlers
                                                           .signature_help,
                                                       { border = "rounded" })
  --]]

  require'ht.core.event'.on('CursorHold', {
    pattern = '*',
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
    end,
  })

  vim.cmd [[packadd nvim-navic]]
  vim.cmd [[packadd rust-tools.nvim]]
  vim.cmd [[packadd cmp-nvim-lsp]]

  require'nvim-navic'.setup {
    highlight = false,
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

