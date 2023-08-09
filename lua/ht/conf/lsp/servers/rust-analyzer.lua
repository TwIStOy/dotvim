local RightClick = require("ht.core.right-click")
local CoreConst = require("ht.core.const")
local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "rust-analyzer"

opts.setup = function(on_attach, capabilities)
  require("rust-tools").setup {
    tools = {
      on_initialized = function()
        vim.notify("rust-analyzer initialize done")
      end,
      inlay_hints = { auto = true },
    },
    server = {
      cmd = {
        CoreConst.mason_bin .. "/rust-analyzer",
      },
      on_attach = on_attach,
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
end

opts.right_click = {
  {
    index = RightClick.indexes.rust_tools,
    enabled = {
      filetype = "rust",
    },
    items = {
      {
        "Rust",
        keys = { "R" },
        children = {
          {
            "Hover Actions",
            callback = function()
              require("rust-tools").hover_actions.hover_actions()
            end,
          },
          {
            "Open Cargo",
            callback = function()
              require("rust-tools").open_cargo_toml.open_cargo_toml()
            end,
            keys = { "c" },
            desc = "open project Cargo.toml",
          },
          {
            "Move Item Up",
            callback = function()
              require("rust-tools").move_item.move_item(true)
            end,
          },
          {
            "Expand Macro",
            callback = function()
              require("rust-tools").expand_macro.expand_macro()
            end,
            desc = "expand macros recursively",
            keys = { "e", "E" },
          },
          {
            "Parent Module",
            callback = function()
              require("rust-tools").parent_module.parent_module()
            end,
            keys = { "p" },
          },
          {
            "Join Lines",
            callback = function()
              require("rust-tools").join_lines.join_lines()
            end,
          },
        },
      },
    },
  },
}

opts.function_sets = {
  {
    category = "Rust Analyzer",
    functions = {
      {
        title = "Open cargo.toml",
        f = function()
          require("rust-tools").open_cargo_toml.open_cargo_toml()
        end,
      },
    },
    filter = function(buffer)
      for _, server in ipairs(buffer.lsp_servers) do
        if server.name == "rust-analyzer" then
          return true
        end
      end
      return false
    end,
  },
}

return CoreLspServer.new(opts)
