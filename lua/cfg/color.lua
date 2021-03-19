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

local color_map = {
  bg = vim_nightfly_color_map.black_normal,
  normal = vim_nightfly_color_map.blue_normal,
  insert = vim_nightfly_color_map.white_normal,
  replace = vim_nightfly_color_map.yellow_normal,
  visual = vim_nightfly_color_map.green_normal,
  command = vim_nightfly_color_map.cyan_normal,
  terminal = vim_nightfly_color_map.green_normal,
  none = vim_nightfly_color_map.cyan_normal,
  yellow_bright = vim_nightfly_color_map.yellow_bright,
  green_bright = vim_nightfly_color_map.green_bright,
  red_bright = vim_nightfly_color_map.red_bright,
  white_bright = vim_nightfly_color_map.white_bright,
}

return color_map

