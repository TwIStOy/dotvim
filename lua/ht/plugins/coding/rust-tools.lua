return {
  Use {
    "simrat39/rust-tools.nvim",
    lazy = {
      lazy = true,
      dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    },
    category = "RustTools",
    functions = {
      {
        filter = {
          ---@param buffer VimBuffer
          filter = function(buffer)
            for _, server in ipairs(buffer.lsp_servers) do
              if server.name == "rust_analyzer" then
                return true
              end
            end
            return false
          end,
        },
        values = {
          FuncSpec("Open cargo.toml of this file", function()
            require("rust-tools").open_cargo_toml.open_cargo_toml()
          end),
          FuncSpec("Open parent module of this file", function()
            require("rust-tools").parent_module.parent_module()
          end),
        },
      },
    },
  },
}
