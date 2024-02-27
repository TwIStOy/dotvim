---@type dora.core.plugin.PluginOption
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    ---@type dora.config
    local config = require("dora.config")

    return {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = config.icon.predefined_icon(
              "DiagnosticError",
              1
            ),
            [vim.diagnostic.severity.WARN] = config.icon.predefined_icon(
              "DiagnosticWarn",
              1
            ),
            [vim.diagnostic.severity.INFO] = config.icon.predefined_icon(
              "DiagnosticInfo",
              1
            ),
            [vim.diagnostic.severity.HINT] = config.icon.predefined_icon(
              "DiagnosticHint",
              1
            ),
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
    }
  end,
  config = function(_, opts)
    ---@type dora.lib
    local lib = require("dora.lib")
    ---@type dora.config
    local config = require("dora.config")

    vim.diagnostic.config(vim.deepcopy(opts.diagnostic))

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      lib.func.require_then("cmp_nvim_lsp", function(cmp_nvim_lsp)
        return cmp_nvim_lsp.default_capabilities()
      end) or {},
      config.lsp.config.capabilities or {}
    )

    local function setup_server(server, server_opts)
      local final_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, server_opts or {})

      local custom_setup = config.lsp.config.setups[server]
      local common_setup = config.lsp.config.setups["*"]
      if custom_setup then
        if custom_setup(server, final_opts) then
          return
        end
      elseif common_setup then
        if common_setup(server, final_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(final_opts)
    end

    vim.print(config.lsp.config)

    for server, server_opts in pairs(config.lsp.config.server_opts or {}) do
      setup_server(server, server_opts)
    end
  end,
}
