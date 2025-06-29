---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.lua",
  deps = {
    "coding",
    "lsp",
    "treesitter",
    "editor",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
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
          vim.fn.expand("$HOME/.dotvim/lua"),
        }
        local add_plugins = {
          "lazy.nvim",
          "plenary.nvim",
          "noice.nvim",
          "nui.nvim",
          "plenary.nvim",
          "nui-components.nvim",
          "nvim-spectre",
          "LuaSnip",
          "hydra.nvim",
          "edgy.nvim",
          "overseer.nvim",
          "which-key.nvim",
        }
        for _, plugin in ipairs(add_plugins) do
          table.insert(
            libraries,
            vim.fn.stdpath("data") .. "/lazy/" .. plugin .. "/lua"
          )
        end
        opts.servers.opts.lua_ls = {
          -- cmd = {
          --   "lua-language-server",
          --   "--logpath=/tmp",
          --   "--loglevel=trace",
          -- },
          settings = {
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
          },
        }
      end,
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
        },
      },
    },
    {
      "dial.nvim",
      opts = function(_, opts)
        local function define_custom(...)
          local augend = require("dial.augend")
          return augend.constant.new {
            elements = { ... },
            word = true,
            cyclic = true,
          }
        end

        if opts.ft.lua == nil then
          opts.ft.lua = {}
        end

        vim.list_extend(opts.ft.lua, {
          define_custom("==", "~="),
        })
      end,
    },
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.extra.ensure_installed, {
          "lua-language-server",
          "stylua",
        })
      end,
    },
  },
}
