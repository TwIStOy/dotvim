---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.plugin.PluginOption
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    return {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        -- },
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
        enabled = true,
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

    local lsp_capabilities = {}

    if vim.g.dotvim_completion_engine == "nvim-cmp" then
      lsp_capabilities = Utils.fn.require_then(
        "cmp_nvim_lsp",
        function(cmp_nvim_lsp)
          return cmp_nvim_lsp.default_capabilities()
        end
      ) or {}
    else
      lsp_capabilities = Utils.fn.require_then("blink.cmp", function(blink_cmp)
        return blink_cmp.get_lsp_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        )
      end) or {}
    end

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      lsp_capabilities,
      opts.capabilities or {}
    )

    ---@return string[]?
    local function get_default_cmd(server)
      local ok, server_module = pcall(require, "lspconfig.configs." .. server)
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

    if Utils.nix.is_nix_managed() then
      -- setup servers immediately
      for server, _ in pairs(opts.servers.opts) do
        setup_server(server)
      end
    else
      local setup_all_servers_and_attach_missing_lsp_servers = function()
        for server, _ in pairs(opts.servers.opts) do
          setup_server(server)
        end

        -- for all currently opened buffers, try to attach to the LSP server
        -- get all buffers
        local buffers = vim.api.nvim_list_bufs()
        for _, buf in ipairs(buffers) do
          if
            not vim.api.nvim_buf_is_loaded(buf)
            or not vim.api.nvim_buf_is_valid(buf)
          then
            goto continue
          end
          local ft = vim.api.nvim_get_option_value("filetype", {
            buf = buf,
          })
          if ft == "" then
            goto continue
          end

          for _, server_name in
            ipairs(require("lspconfig.util").available_servers())
          do
            local server = require("lspconfig")[server_name]
            if
              server.filetypes ~= nil
              and vim.list_contains(server.filetypes, ft)
            then
              server.launch(buf)
            end
          end

          ::continue::
        end
      end

      if vim.g.dotvim_mason_setup_done == true then
        -- setup immediately
        setup_all_servers_and_attach_missing_lsp_servers()
      else
        -- wait for mason.nvim has been initialized
        vim.api.nvim_create_autocmd("User", {
          pattern = "MasonSetupDone",
          once = true,
          callback = setup_all_servers_and_attach_missing_lsp_servers,
        })
      end
    end
  end,
}
