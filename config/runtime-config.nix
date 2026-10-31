{...}: {
  # Runtime configuration, deep-merged over the defaults below from, in
  # increasing precedence:
  #   1. nix defaults (below)
  #   2. ~/.config/dotvim/config.json (user)
  #      {"theme": "bamboo", "cpp_lsp": "clice"}
  #   3. .dotvim.json project files, collected editorconfig-style by walking
  #      from the filesystem root down to the startup cwd; the file nearest
  #      to the cwd wins on conflicts
  # Missing files are skipped. Invalid JSON in a file -> WARN + that file is
  # ignored; a value of the wrong type inside a merged key -> WARN + the
  # merge that involved it is skipped.
  #
  # Runs in extraConfigLuaPost: after plugins and after startup OSC 11
  # background detection (so background-following colorschemes pick the
  # correct variant at load), but before exrc — a trusted project
  # .nvim.lua runs after init and can still override anything set here.
  # Precedence: nix defaults < config.json < .dotvim.json (outer→inner)
  #             < project .nvim.lua.
  #
  # Known keys:
  #   theme   — colorscheme applied here; unknown name -> WARN + circadia
  #   cpp_lsp — feeds vim.g.dotvim_cpp_lsp; validated and enabled at
  #             VimEnter by config/plugins/langs/cpp.nix
  extraConfigLuaPost = ''
    do
      local defaults = {
        theme = "circadia",
        cpp_lsp = "clangd",
      }

      -- Returns {} for a missing file; WARN + {} for invalid JSON.
      local function load_json_config(path)
        local f = io.open(path, "r")
        if not f then
          return {}
        end
        local content = f:read("*a")
        f:close()
        local ok, cfg = pcall(vim.json.decode, content)
        if not ok or type(cfg) ~= "table" then
          vim.notify("dotvim: invalid JSON in " .. path, vim.log.levels.WARN)
          return {}
        end
        return cfg
      end

      local function merge_config(dst, src, source)
        local ok, merged = pcall(vim.tbl_deep_extend, "force", dst, src)
        if not ok then
          vim.notify(
            "dotvim: could not merge " .. source .. " into the current config",
            vim.log.levels.WARN
          )
          return dst
        end
        return merged
      end

      -- User config: $XDG_CONFIG_HOME/dotvim/config.json
      local config_dir =
        (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/dotvim"
      local cfg = merge_config(
        defaults,
        load_json_config(config_dir .. "/config.json"),
        config_dir .. "/config.json"
      )

      -- Project configs: every .dotvim.json from the filesystem root down
      -- to the startup cwd, merged outermost-first so nearer files win.
      local found = {}
      local dir = vim.uv.fs_realpath(vim.fn.getcwd())
      while dir do
        local candidate = dir .. "/.dotvim.json"
        if vim.fn.filereadable(candidate) == 1 then
          table.insert(found, candidate)
        end
        if dir == "/" then
          break
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      for i = #found, 1, -1 do
        cfg = merge_config(cfg, load_json_config(found[i]), found[i])
      end

      vim.g.dotvim_config = cfg

      local theme = cfg.theme
      if type(theme) ~= "string" or theme == "" then
        vim.notify("dotvim: config.theme must be a non-empty string", vim.log.levels.WARN)
        theme = "circadia"
      end
      if not pcall(vim.cmd.colorscheme, theme) then
        vim.notify(
          'dotvim: unknown theme "' .. theme .. '", falling back to circadia',
          vim.log.levels.WARN
        )
        vim.cmd.colorscheme("circadia")
      end

      vim.g.dotvim_cpp_lsp = cfg.cpp_lsp
    end
  '';
}
