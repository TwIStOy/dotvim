---@type dotvim.utils
local Utils = require("dora.utils")

---@type dotvim.core.plugin.PluginOption
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
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
            [vim.diagnostic.severity.ERROR] = Utils.icon.predefined_icon(
              "DiagnosticError",
              1
            ),
            [vim.diagnostic.severity.WARN] = Utils.icon.predefined_icon(
              "DiagnosticWarn",
              1
            ),
            [vim.diagnostic.severity.INFO] = Utils.icon.predefined_icon(
              "DiagnosticInfo",
              1
            ),
            [vim.diagnostic.severity.HINT] = Utils.icon.predefined_icon(
              "DiagnosticHint",
              1
            ),
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
      capabilities = {},
      servers = {
        opts = {},
        setup = {},
      },
    }
  end,
  config = function(_, opts)
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      Utils.fn.require_then("cmp_nvim_lsp", function(cmp_nvim_lsp)
        return cmp_nvim_lsp.default_capabilities()
      end) or {},
      opts.capabilities or {}
    )

    ---@return string[]?
    local function get_default_cmd(server)
      local ok, server_module =
        pcall(require, "lspconfig.server_configurations." .. server)
      if not ok then
        return nil
      end
      local default_config = server_module.default_config
      return default_config.cmd
    end

    ---@param cmd string[]
    local function try_to_replace_executable_from_nix_or_mason(cmd)
      local executable = cmd[1]
      local new_executable = Utils.which(executable)
      return { new_executable, unpack(cmd, 2) }
    end

    ---@param server string
    local function setup_server(server)
      local server_opts = opts.servers.opts[server] or {}
      local server_setup = opts.servers.setup[server]
      local common_setup = opts.servers.setup["*"]

      server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, server_opts)

      if server_opts.cmd ~= nil then
        server_opts.cmd =
          try_to_replace_executable_from_nix_or_mason(server_opts.cmd)
      else
        local default_cmd = get_default_cmd(server)
        if default_cmd ~= nil then
          server_opts.cmd =
            try_to_replace_executable_from_nix_or_mason(default_cmd)
        end
      end

      if server_setup ~= nil then
        server_setup(server, server_opts)
        return
      elseif common_setup ~= nil then
        common_setup(server, server_opts)
        return
      else
        require("lspconfig")[server].setup(server_opts)
      end
    end

    for server, _ in pairs(opts.servers.opts) do
      setup_server(server)
    end
  end,
}
