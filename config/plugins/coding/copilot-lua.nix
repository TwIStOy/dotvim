{pkgs, ...}: {
  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings = {
      event = "InsertEnter";
      cmd = "Copilot";
    };
    settings = {
      copilot_node_command = "${pkgs.nodejs}/bin/node";
      # Refuse to attach to sensitive files (env / secrets) so their contents
      # are never sent to Copilot. Kept in sync with the Lua spec's
      # `copilot_should_attach` in lua/dotvim/plugins/ai/copilot.lua.
      # NOTE: the `ne` build does not load lua/dotvim/**, so this is inlined
      # rather than reaching for dotvim.commons.fs.is_sensitive_file.
      should_attach = {__raw = ''
        function(bufnr, bufname)
          local name = type(bufname) == "string" and vim.fn.fnamemodify(bufname, ":t"):lower() or ""
          local sensitive = name == ".envrc"
            or name == "secrets.yaml"
            or name == "secrets.yml"
            or name == "secrets.json"
            or name == "secrets.jsonc"
            or name == ".env"
            or vim.startswith(name, ".env.")
            or vim.endswith(name, ".env")
          if sensitive then
            return false
          end
          if not vim.bo[bufnr].buflisted then
            return false
          end
          if vim.bo[bufnr].buftype ~= "" then
            return false
          end
          return true
        end
      '';};
      suggestion = {
        auto_trigger = true;
        keymap.accept = "<C-l>";
      };
      server_opts_overrides = {
        cmd_env = {
          NODE_TLS_REJECT_UNAUTHORIZED = "0";
        };
      };
    };
    luaConfig.post = ''
      local current_status = { status = "", message = "" }
      _G.dotvim_copilot_get_status = function()
        return current_status.status or ""
      end
      vim.schedule(function()
        local ok, status_mod = pcall(require, "copilot.status")
        if ok and status_mod.register_status_notification_handler then
          status_mod.register_status_notification_handler(function(data)
            current_status = data
            local ok_lualine, lualine = pcall(require, "lualine")
            if ok_lualine then
              pcall(lualine.refresh)
            end
          end)
        end
      end)
    '';
  };
}
