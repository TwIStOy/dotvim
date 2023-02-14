local M = {}

M = {
  'hoob3rt/lualine.nvim',
  event = "VeryLazy",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  }
}

local options = {
  section_separators = { '', '' },
  component_separators = { '', '' },
  theme = 'auto',
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { 'filename' },
  lualine_x = { 'location' },
  lualine_y = {},
  lualine_z = {},
}

M.opts = function() -- code to run after plugin loaded
  -- local navic = require 'nvim-navic'

  require'lualine'.setup {
    options = options,
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        'diff',
        {
          'diagnostics',
          sources = { 'nvim_diagnostic', 'coc' },
          sections = { 'error', 'warn', 'info', 'hint' },
          diagnostics_color = {
            error = 'DiagnosticError',
            warn = 'DiagnosticWarn',
            info = 'DiagnosticInfo',
            hint = 'DiagnosticHint',
          },
          symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
          colored = true,
          update_in_insert = false,
          always_visible = false,
        },
      },
      lualine_c = {
        'filename',
        -- { navic.get_location, cond = navic.is_available },
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = inactive_sections,
    tabline = {},
    extensions = {},
  }
end

return M
