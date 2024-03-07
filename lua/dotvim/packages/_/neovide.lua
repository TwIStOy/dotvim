local M = {}

local function toggle_ime(args)
  if args.event:match("Enter$") then
    vim.g.neovide_input_ime = true
  else
    vim.g.neovide_input_ime = false
  end
end

function M.setup()
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_transparency = 1
  vim.g.neovide_window_blurred = true

  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_profiler = false
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_no_idle = true
  vim.g.neovide_input_macos_alt_is_meta = true

  vim.g.neovide_cursor_animation_length = 0.2
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_antialiasing = true

  vim.g.neovide_floating_blur_amount_x = 6.0
  vim.g.neovide_floating_blur_amount_y = 6.0

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.g.neovide_scroll_animation_length = 0.2

  vim.g.neovide_underline_automatic_scaling = true
  vim.g.neovide_underline_stroke_scale = 0.6

  vim.o.winblend = 30
  vim.o.pumblend = 30

  vim.g.neovide_input_ime = false

  local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = toggle_ime,
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = toggle_ime,
  })

  -- clipboard
  vim.keymap.set({ "n", "i", "c", "v" }, "<D-v>", function()
    local register_info = vim.fn.getreginfo("+")
    local content = {}
    if register_info.regcontents then
      content = register_info.regcontents
    end
    vim.api.nvim_paste(table.concat(content, "\n"), true, -1)
  end, { silent = true })
end

return M
