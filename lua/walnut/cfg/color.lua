local vim_nightfly_color_map = {
  bg = '#011627',
  fg = '#acb4c2',
  bold = '#eeeeee',
  cursor = '#9ca1aa',
  cursor_text = '#080808',
  section = '#b2ceee',
  section_text = '#080808',
  black_normal = '#1d3b53',
  red_normal =	'#fc514e',
  green_normal	= '#a1cd5e',
  yellow_normal	= '#e3d18a',
  blue_normal	= '#82aaff',
  purple_normal	= '#c792ea',
  cyan_normal	= '#7fdbca',
  white_normal	= '#a1aab8',
  black_bright	= '#7c8f8f',
  red_bright	= '#ff5874',
  green_bright	= '#21c7a8',
  yellow_bright	= '#ecc48d',
  blue_bright	= '#82aaff',
  purple_bright	= '#ae81ff',
  cyan_bright	= '#7fdbca',
  white_bright	= '#d6deeb',
}

local vim_nord_color_map = {
  nord0_gui = "#2E3440",
  nord1_gui = "#3B4252",
  nord2_gui = "#434C5E",
  nord3_gui = "#4C566A",
  nord3_gui_bright = "#616E88",
  nord4_gui = "#D8DEE9",
  nord5_gui = "#E5E9F0",
  nord6_gui = "#ECEFF4",
  nord7_gui = "#8FBCBB",
  nord8_gui = "#88C0D0",
  nord9_gui = "#81A1C1",
  nord10_gui = "#5E81AC",
  nord11_gui = "#BF616A",
  nord12_gui = "#D08770",
  nord13_gui = "#EBCB8B",
  nord14_gui = "#A3BE8C",
  nord15_gui = "#B48EAD",
}

-- nord
local color_map = {
  bg0 = vim_nord_color_map.nord0_gui,
  bg = vim_nord_color_map.nord1_gui,
  bg1 = vim_nord_color_map.nord3_gui,
  normal = vim_nord_color_map.nord4_gui,
  insert = vim_nord_color_map.nord1_gui,
  replace = vim_nord_color_map.nord8_gui,
  visual = vim_nord_color_map.nord9_gui,
  command = vim_nord_color_map.nord10_gui,
  terminal = vim_nord_color_map.nord11_gui,
  none = vim_nord_color_map.nord4_gui,
  yellow_bright = vim_nord_color_map.nord13_gui,
  green_bright = vim_nord_color_map.nord14_gui,
  red_bright = vim_nord_color_map.nord11_gui,
  orange_bright = vim_nord_color_map.nord12_gui,
  purple_bright = vim_nord_color_map.nord15_gui,
  white_bright = vim_nord_color_map.nord6gui,
  bg_bright = vim_nord_color_map.nord3_gui_bright,
  get_hl_by_name_fg = function(name)
    local v = vim.api.nvim_get_hl_by_name(name, 1).foreground
    if v ~= nil then
      return string.format("#%x", v)
    else
      return ''
    end
  end,
  get_hl_by_name_bg = function(name)
    local v = vim.api.nvim_get_hl_by_name(name, 1).background
    if v ~= nil then
      return string.format("#%x", v)
    else
      return ''
    end
  end,
}

return color_map

