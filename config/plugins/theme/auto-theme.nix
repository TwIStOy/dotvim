{
  lib,
  config,
  ...
}: let
  cfg = config.dotvim.theme;
in {
  options.dotvim.theme = {
    dark = lib.mkOption {
      type = lib.types.str;
      default = "chad46_ayu_dark";
      description = "Colorscheme used when the terminal background is dark (OSC 11).";
    };

    light = lib.mkOption {
      type = lib.types.str;
      default = "chad46_ayu_light";
      description = "Colorscheme used when the terminal background is light (OSC 11).";
    };
  };

  config = {
    # Runs in extraConfigLuaPost (after every plugin's extraConfigLua), so
    # whichever plugin backs `dark`/`light` is already set up. The TUI sets
    # 'background' from the OSC 11 response before user config runs, so it
    # is already correct here; the OptionSet autocmd re-applies on live
    # terminal theme changes (DEC mode 2031 notification -> re-query).
    #
    # We track the last-applied target in a local instead of reading
    # g:colors_name: colorschemes are free to set g:colors_name to anything
    # (e.g. chad46's base scheme sets it to "chad46"), so it is not a
    # reliable signal for "is the desired theme already loaded".
    extraConfigLuaPost = ''
      local current_theme
      local function apply_theme()
        local target = vim.o.background == "light" and ${builtins.toJSON cfg.light} or ${builtins.toJSON cfg.dark}
        if current_theme == target then
          return
        end
        current_theme = target
        vim.cmd.colorscheme(target)
      end

      apply_theme()

      vim.api.nvim_create_autocmd("OptionSet", {
        group = vim.api.nvim_create_augroup("DotvimAutoTheme", { clear = true }),
        pattern = "background",
        callback = apply_theme,
      })
    '';
  };
}
