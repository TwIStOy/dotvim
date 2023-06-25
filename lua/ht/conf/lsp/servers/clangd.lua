local RightClick = require("ht.core.right-click")
local Const = require("ht.core.const")

local function t_cmd(s, cmd)
  return {
    s,
    callback = function()
      vim.cmd(cmd)
    end,
  }
end

---@type ht.LspConf
local M = {}

M.name = "clangd"

local function on_attach(default_callback)
  return function(client, bufnr)
    default_callback(client, bufnr)
    vim.keymap.set("n", "<leader>fa", function()
      vim.cmd("ClangdSwitchSourceHeader")
    end, {
      desc = "clangd-switch-header",
      buffer = bufnr,
    })
  end
end

M.setup = function(on_buffer_attach, capabilities)
  require("clangd_extensions").setup {
    server = {
      cmd = {
        Const.mason_bin .. "/clangd",
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
      on_attach = on_attach(on_buffer_attach),
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
end

M.right_click = {
  {
    index = RightClick.indexes.clangd,
    enabled = {
      filetype = {
        "cpp",
        "c",
      },
    },
    items = {
      t_cmd("Symbol Info", "ClangdSymbolInfo"),
      t_cmd("Type Hierarchy", "ClangdTypeHierarchy"),
      {
        "Clangd More",
        children = {
          t_cmd("View AST", "ClangdAST"),
          t_cmd("Memory Usage", "ClangdMemoryUsage"),
        },
      },
    },
  },
}

M.function_sets = {
  {
    category = "Clangd",
    functions = {
      {
        title = "Switch between source and header",
        f = function()
          vim.cmd("ClangdSwitchSourceHeader")
        end,
      },
    },
    ---@param buffer VimBuffer
    filter = function(buffer)
      for _, server in ipairs(buffer.lsp_servers) do
        if server.name == "clangd" then
          return true
        end
      end
      return false
    end,
  },
}

return M
