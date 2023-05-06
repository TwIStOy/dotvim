local RightClick = require("ht.core.right-click")
local call_once = require("ht.utils.func").call_once
local FF = require("ht.core.functions")

local function t_cmd(s, cmd)
  return {
    s,
    callback = function()
      vim.cmd(cmd)
    end,
  }
end

local function setup()
  RightClick.add_section {
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
  }

  FF:add_function_set {
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
  }
end

return call_once(setup)
