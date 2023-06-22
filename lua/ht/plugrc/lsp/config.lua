local M = {}

local on_buffer_attach = require("ht.plugrc.lsp.on_attach")

M.config = function() -- code to run after plugin loaded
  --- add menus for specific types
  local LSP = require("ht.with_plug.lsp")
  local MASON = require("ht.with_plug.mason")

  require("ht.plugrc.lsp.servers.clangd")()
  require("ht.plugrc.lsp.servers.rust-analyzer")()
  require("ht.plugrc.lsp.servers.default")()

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      severity_sort = true,
      signs = true,
      update_in_insert = false,
      underline = true,
    })

  local capabilities = LSP.client_capabilities()

  local signs =
    { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- force utf16 only
  capabilities.offsetEncoding = { "utf-16" }

  require("clangd_extensions").setup {
    server = {
      cmd = {
        MASON.bin("clangd")[1],
        "--clang-tidy",
        "--background-index",
        "--background-index-priority=normal",
        "--ranking-model=decision_forest",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--limit-references=100",
        "--limit-results=100",
        "--include-cleaner-stdlib",
        "-j=20",
      },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
      filetypes = {
        "c",
        "cpp",
      },
    },
    extensions = {
      autoSetHints = false,
      hover_with_actions = true,
      inlay_hints = {
        inline = false,
        only_current_line = false,
        only_current_line_autocmd = "CursorHold",
        show_parameter_hints = false,
        show_variable_name = true,
        other_hints_prefix = "",
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

  require("rust-tools").setup {
    tools = {
      on_initialized = function()
        vim.notify("rust-analyzer initialize done")
      end,
      inlay_hints = { auto = true },
    },
    server = {
      cmd = { "rustup", "run", "stable", "rust-analyzer" },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { buildScripts = { enable = true } },
          procMacro = { enable = true },
          check = {
            command = "clippy",
            extraArgs = { "--all", "--", "-W", "clippy::all" },
          },
          completion = { privateEditable = { enable = true } },
          diagnostic = {
            enable = true,
            disabled = { "inactive-code" },
          },
        },
      },
    },
  }

  require("lspconfig").pyright.setup {
    cmd = {
      MASON.bin("pyright", "pyright-langserver")[1],
      "--stdio",
    },
    on_attach = on_buffer_attach,
    capabilities = capabilities,
  }

  local lua_library = {
    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
  }
  if package.loaded["lazy"] then
    local lazy_plugins = require("lazy").plugins()
    for _, plugin in ipairs(lazy_plugins) do
      lua_library[plugin.dir] = true
    end
  end
  lua_library = vim.tbl_deep_extend(
    "force",
    lua_library,
    vim.api.nvim_get_runtime_file("", true)
  )
  require("lspconfig").lua_ls.setup {
    cmd = MASON.bin("lua-language-server"),
    on_attach = on_buffer_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          globals = { "vim" },
          -- neededFileStatus = { ["codestyle-check"] = "Any" },
        },
        workspace = { library = lua_library },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            continuation_indent_size = "2",
          },
        },
      },
    },
  }

  require("lspconfig").cmake.setup {
    cmd = MASON.bin("cmake-language-server"),
    on_attach = on_buffer_attach,
    capabilities = capabilities,
    initializationOptions = { buildDirectory = "build" },
  }

  local rime = require("ht.plugrc.lsp.custom.rime")
  rime.setup()
  require("lspconfig").rime_ls.setup {
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

  require("lspconfig").tsserver.setup {
    cmd = {
      MASON.bin("typescript-language-server")[1],
      "--stdio",
    },
    on_attach = on_buffer_attach,
    capabilities = capabilities,
  }

  -- init sourcekit in macos
  if vim.fn.has("macunix") then
    require("lspconfig").sourcekit.setup {
      filetypes = { "swift", "objective-c", "objective-cpp" },
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    }
  end

  MASON.ensure_installed()
end

return M
