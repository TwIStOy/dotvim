local RightClick = require("ht.core.right-click")
local call_once = require("ht.utils.func").call_once
local FF = require("ht.core.functions")
local LSP = require("ht.with_plug.lsp")

local function setup()
  FF:add_function_set {
    category = "Editor",
    functions = {
      {
        title = "Format document",
        f = LSP.format,
      },
    },
  }

  FF:add_function_set {
    category = "RimeLS",
    functions = {
      {
        title = "Sync user data",
        f = function()
          vim.lsp.buf.execute_command { command = "rime-ls.sync-user-data" }
        end,
      },
    },
    ---@param buffer VimBuffer
    filter = function(buffer)
      for _, server in ipairs(buffer.lsp_servers) do
        if server.name == "rime_ls" then
          return true
        end
      end
      return false
    end,
  }

  RightClick.add_section {
    index = RightClick.indexes.lsp,
    enabled = {
      others = require("right-click.filters.lsp").lsp_attached,
    },
    items = {
      {
        "LSP",
        keys = "g",
        children = {
          {
            "Goto Declaration",
            callback = LSP.declaration,
            keys = { "d" },
          },
          {
            "Goto Definition",
            callback = LSP.definitions,
            keys = "D",
          },
          {
            "Goto Implementation",
            callback = LSP.implementations,
            keys = "i",
          },
          {
            "Inspect References",
            callback = LSP.references,
            keys = "r",
          },
          { "Rname", callback = LSP.rename, keys = "R" },
        },
      },
    },
  }
end

return call_once(setup)
