local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = function(_, opts)
    opts = opts or {}
    return vim.tbl_deep_extend("keep", opts, {
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
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
      capabilities = {
        offsetEncoding = { "utf-16" },
      },
      server_opts = {},
    })
  end,
  config = function(_, opts)
    vim.diagnostic.config(vim.deepcopy(opts.diagnostic))

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      lib.fn.require_then("cmp_nvim_lsp", function(cmp_nvim_lsp)
        cmp_nvim_lsp.default_capabilities()
      end) or {},
      opts.capabilities or {}
    )

    local function setup_server(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, opts.servers_opts[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end

    for server, _ in pairs(opts.server_opts) do
      setup_server(server)
    end
  end,
}
