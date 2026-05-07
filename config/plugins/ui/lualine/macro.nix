{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_macro = {
      function()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
          return ""
        else
          return "recording @" .. recording_register
        end
      end,
      color = {
        bg = _G.dotvim_resolve_fg("Error"),
        fg = _G.dotvim_resolve_fg("IncSearch"),
        gui = "bold",
      },
      separator = { left = "", right = "" },
    }
  '';
}
