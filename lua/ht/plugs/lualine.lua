module('ht.plugs.lualine', package.seeall)

local options = {
  section_separators = {'', ''},
  component_separators = {'', ''},
  theme = 'auto'
}

local function coc_status()
  local s = vim.g.coc_status
  if s == nil or s == '' then
    return ''
  else
    return s
  end
end

local sections = {
  lualine_a = {'mode'},
  lualine_b = {coc_status, 'branch', 'diff'},
  lualine_c = {'filename'},
  lualine_x = {'encoding', 'fileformat', 'filetype'},
  lualine_y = {'progress'},
  lualine_z = {'location'}
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {'filename'},
  lualine_x = {'location'},
  lualine_y = {},
  lualine_z = {}
}

function config()
  require'lualine'.setup {
    options = options,
    sections = sections,
    inactive_sections = inactive_sections,
    tabline = {},
    extensions = {}
  }
end

-- vim: et sw=2 ts=2

