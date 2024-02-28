---@type dora.core.package.PackageOption
return {
  name = "extra.lang.lua",
  deps = {
    "coding",
    "lsp",
    "treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          if vim.list_contains(opts.ensure_installed, "lua") then
            return
          end
          vim.list_extend(opts.ensure_installed, { "lua" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = function(_, opts)
        local libraries = {
          "${3rd}/luassert/library",
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
        }
        local add_plugins = {
          "lazy.nvim",
          "plenary.nvim",
          "noice.nvim",
          "nui.nvim",
          "plenary.nvim",
        }
        for _, plugin in ipairs(add_plugins) do
          table.insert(
            libraries,
            vim.fn.stdpath("data") .. "/lazy/" .. plugin .. "/lua"
          )
        end

        opts.servers.opts.lua_ls = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              globals = { "vim" },
              disable = {},
            },
            workspace = { library = libraries },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                continuation_indent_size = "2",
              },
            },
          },
        }
      end,
    },
  },
}
