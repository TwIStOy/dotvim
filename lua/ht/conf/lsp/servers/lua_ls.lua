local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "lua_ls"

M.mason_pkg = "lua-language-server"

M.setup = function(on_attach, capabilities)
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
    cmd = {
      Const.mason_bin .. "/lua-language-server",
    },
    on_attach = on_attach,
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
end

return M
