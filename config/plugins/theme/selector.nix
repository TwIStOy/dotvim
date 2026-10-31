{...}: {
  # Runtime theme selection without a rebuild:
  #   ~/.config/dotvim/config.json  ->  {"theme": "bamboo"}
  # Missing file or invalid/unknown theme falls back to circadia.
  #
  # This runs in extraConfigLuaPost — after plugins load and after
  # Neovim's startup OSC 11 background detection, so background-following
  # schemes pick the correct variant at load time. It must not set
  # 'background' itself (that would disable Neovim's OSC 11 handler).
  extraConfigLuaPost = ''
    do
      local config_path =
        (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/dotvim/config.json"

      local function read_theme()
        local f = io.open(config_path, "r")
        if not f then
          return nil
        end
        local content = f:read("*a")
        f:close()
        local ok, cfg = pcall(vim.json.decode, content)
        if not ok then
          vim.notify("dotvim: invalid JSON in " .. config_path, vim.log.levels.WARN)
          return nil
        end
        if cfg.theme == nil then
          return nil
        end
        if type(cfg.theme) ~= "string" or cfg.theme == "" then
          vim.notify("dotvim: config.theme must be a non-empty string", vim.log.levels.WARN)
          return nil
        end
        return cfg.theme
      end

      local theme = read_theme()
      if theme and not pcall(vim.cmd.colorscheme, theme) then
        vim.notify(
          'dotvim: unknown theme "' .. theme .. '" in ' .. config_path .. ", falling back to circadia",
          vim.log.levels.WARN
        )
        theme = nil
      end
      if not theme then
        vim.cmd.colorscheme("circadia")
      end
    end
  '';
}
