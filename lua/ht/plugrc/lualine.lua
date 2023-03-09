local M = {}

M = {
  'hoob3rt/lualine.nvim',
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

local options = {
  component_separators = "|",
  section_separators = { left = "", right = "" },

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

local function get_cwd()
  local cwd = vim.fn.getcwd()
  local home = os.getenv("HOME")
  if cwd:find(home, 1, true) == 1 then
    cwd = "~" .. cwd:sub(#home + 1)
  end
  return cwd
end

local function session_name()
  local session = require('possession.session')
  if session ~= nil then
    return session.session_name or ''
  end
  return ''
end

M.opts = function() -- code to run after plugin loaded
  local navic = require 'nvim-navic'
  local rime = require 'ht.plugrc.lsp.custom.rime'

  require'lualine'.setup {
    options = options,
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        { 'filename', path = 1 },
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
        { navic.get_location, cond = navic.is_available },
      },
      lualine_x = { get_cwd },
      lualine_y = {
        { rime.rime_state },
        { "filetype", colored = true, icon_only = false },
        'encoding',
        'fileformat',
      },
      lualine_z = { 'progress', 'location', session_name },
    },
    inactive_sections = inactive_sections,
    tabline = {},
    extensions = {},
  }
end

return M

