{pkgs, ...}: {
  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings = {
      event = "InsertEnter";
      cmd = "Copilot";
    };
    settings = {
      copilot_node_command = "${pkgs.nodejs}/bin/node";
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
