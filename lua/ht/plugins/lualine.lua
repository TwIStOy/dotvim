local M = {}

M.core = {
  'hoob3rt/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons' },
  after = 'github-nvim-theme',
}

local options = {
  section_separators = { '', '' },
  component_separators = { '', '' },
  theme = 'auto',
}

local sections = {
  lualine_a = { 'mode' },
  lualine_b = { 'branch', 'diff' },
  lualine_c = { 'filename' },
  lualine_x = { 'encoding', 'fileformat', 'filetype' },
  lualine_y = { 'progress' },
  lualine_z = { 'location' },
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { 'filename' },
  lualine_x = { 'location' },
  lualine_y = {},
  lualine_z = {},
}

M.config = function() -- code to run after plugin loaded
  require'lualine'.setup {
    options = options,
    sections = sections,
    inactive_sections = inactive_sections,
    tabline = {},
    extensions = {},
  }
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

