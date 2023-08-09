local M = {}

function M.setup()
  vim.g.neovide_font_features = {
    ["Iosevka"] = {
      "+ss07",
      "cv49=16",
      "cv94=1",
      "VXLA=2",
      "VXLC=2",
      "cv34=12",
      "cv31=13",
    },
  }

  vim.o.guifont = "Iosevka,Symbols_Nerd_Font:h22"

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_profiler = false
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_no_idle = true
  vim.g.neovide_input_macos_alt_is_meta = true

  vim.g.neovide_input_use_logo = true

  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
end

return M
