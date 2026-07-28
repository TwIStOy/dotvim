{...}: {
  # Inside tmux, OSC 11 is answered with tmux's OWN background colour (e.g.
  # catppuccin mocha), which masks the outer terminal's real theme. tmux tracks
  # the outer terminal's theme separately (Mode 2031 / OSC 11 on the client)
  # and exposes it via the `#{client_theme}` format ("dark"/"light"/empty).
  # Drive 'background' from that when $TMUX is set; catppuccin then follows
  # (mocha/latte). Outside tmux, Neovim's native OSC 11 detection is used.
  extraConfigLuaPost = ''
    if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
      local function sync_background_from_tmux()
        local out = vim.fn.system({ "tmux", "display", "-p", "#{client_theme}" })
        if vim.v.shell_error ~= 0 then
          return
        end
        local theme = vim.trim(out):lower()
        if (theme == "light" or theme == "dark") and vim.o.background ~= theme then
          vim.o.background = theme
        end
      end

      sync_background_from_tmux()

      -- Re-sync on focus so an OS appearance change while nvim is running is
      -- picked up. Needs `set -g focus-events on` in tmux.
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("DotvimTmuxTheme", { clear = true }),
        callback = sync_background_from_tmux,
      })
    end
  '';
}
