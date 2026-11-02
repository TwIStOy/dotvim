{lib, ...}: {
  # Optional user init. The `ne` wrapper sets NVIM_APPNAME=ne, so
  # stdpath("config") is ~/.config/ne, but nixvim loads its init via VIMINIT,
  # which makes neovim skip the user init file entirely. Load it here instead,
  # at the very end of the generated init: after the runtime-config layers
  # (config.json / .dotvim.json theme) and before exrc (.nvim.lua).
  # Precedence: nix < config.json < .dotvim.json < ~/.config/ne/init.lua
  #             < project .nvim.lua. Missing file is a silent no-op; errors
  #             are reported without aborting startup.
  extraConfigLuaPost = lib.mkAfter ''
    do
      local path = vim.fn.stdpath("config") .. "/init.lua"
      if vim.uv.fs_stat(path) then
        local ok, err = pcall(dofile, path)
        if not ok then
          vim.notify(
            "dotvim: error in " .. path .. ":\n" .. err,
            vim.log.levels.ERROR
          )
        end
      end
    end
  '';
}
