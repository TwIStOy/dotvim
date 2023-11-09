local CoreConst = require("ht.core.const")
local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "lua_ls"

opts.mason = { name = "lua-language-server" }

local enabled_plugins = {
  ["telescope.nvim"] = true,
  ["plenary.nvim"] = true,
  ["lazy.nvim"] = true,
  ["nui.nvim"] = true,
}

opts.setup = function(on_attach, capabilities)
  local lua_library = {
    vim.fn.expand("$VIMRUNTIME/lua"),
    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
    "${3rd}/luassert/library",
  }
  if package.loaded["lazy"] then
    local lazy_plugins = require("lazy").plugins()
    local data_path = vim.fn.stdpath("data")
    for _, plugin in ipairs(lazy_plugins) do
      if
        enabled_plugins[plugin.name]
        or plugin.dir:find(data_path, 1, true) ~= 1
      then
        lua_library[#lua_library + 1] = plugin.dir
      end
    end
  end

  require("lspconfig").lua_ls.setup {
    cmd = {
      CoreConst.mason_bin .. "/lua-language-server",
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
          disable = {
            "missing-fields",
          },
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

return CoreLspServer.new(opts)
