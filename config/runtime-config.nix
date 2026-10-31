{...}: {
  # Runtime configuration, deep-merged over the defaults below from
  #   ~/.config/dotvim/config.json
  #     {"theme": "bamboo", "cpp_lsp": "clice"}
  # Missing file -> defaults. Invalid JSON or a value of the wrong type
  # inside a merged key -> WARN + defaults.
  #
  # Runs in extraConfigLuaPost: after plugins and after startup OSC 11
  # background detection (so background-following colorschemes pick the
  # correct variant at load), but before exrc — a trusted project
  # .nvim.lua runs after init and can still override anything set here.
  # Precedence: nix defaults < config.json < project .nvim.lua.
  #
  # Known keys:
  #   theme   — colorscheme applied here; unknown name -> WARN + circadia
  #   cpp_lsp — feeds vim.g.dotvim_cpp_lsp; validated and enabled at
  #             VimEnter by config/plugins/langs/cpp.nix
  extraConfigLuaPost = ''
    do
      local config_path =
        (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/dotvim/config.json"

      local defaults = {
        theme = "circadia",
        cpp_lsp = "clangd",
      }

      local function load_file_config()
        local f = io.open(config_path, "r")
        if not f then
          return {}
        end
        local content = f:read("*a")
        f:close()
        local ok, cfg = pcall(vim.json.decode, content)
        if not ok or type(cfg) ~= "table" then
          vim.notify("dotvim: invalid JSON in " .. config_path, vim.log.levels.WARN)
          return {}
        end
        return cfg
      end

      local ok, cfg = pcall(vim.tbl_deep_extend, "force", defaults, load_file_config())
      if not ok then
        vim.notify(
          "dotvim: could not merge " .. config_path .. " with defaults",
          vim.log.levels.WARN
        )
        cfg = defaults
      end
      vim.g.dotvim_config = cfg

      local theme = cfg.theme
      if type(theme) ~= "string" or theme == "" then
        vim.notify("dotvim: config.theme must be a non-empty string", vim.log.levels.WARN)
        theme = "circadia"
      end
      if not pcall(vim.cmd.colorscheme, theme) then
        vim.notify(
          'dotvim: unknown theme "' .. theme .. '" in ' .. config_path .. ", falling back to circadia",
          vim.log.levels.WARN
        )
        vim.cmd.colorscheme("circadia")
      end

      vim.g.dotvim_cpp_lsp = cfg.cpp_lsp
    end
  '';
}
