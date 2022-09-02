local M = {}

M.core = {
  'Yggdroot/LeaderF',
  cmd = { 'LeaderF', 'LeaderfFile' },
  run = './install.sh',
}

M.setup = function() -- code to run before plugin loaded
  local cmd = vim.api.nvim_command
  local event = require 'ht.core.event'
  local get_opt = vim.api.nvim_get_option

  local function resize_leaderf_window()
    vim.g.Lf_PopupWidth = get_opt('columns') * 3 / 4
    vim.g.Lf_PopupHeight = math.floor(get_opt('lines') * 0.6)
  end

  vim.g.Lf_ShortcutF = '<Leader>ff'
  vim.g.Lf_ShortcutB = '<Leader>ffb'
  vim.g.Lf_WindowPosition = 'popup'
  vim.g.Lf_RecurseSubmodules = 1

  vim.g.Lf_HideHelp = 1
  vim.g.Lf_UseVersionControlTool = 0
  vim.g.Lf_DefaultExternalTool = ''
  vim.g.Lf_WorkingDirectoryMode = 'ac'
  vim.g.Lf_PopupPosition = { 1, 0 }
  vim.g.Lf_FollowLinks = 1
  vim.g.Lf_WildIgnore = {
    dir = {
      '.git',
      '.svn',
      '.hg',
      '.cache',
      '.build',
      '.deps',
      '.third-party-build',
      'build',
    },
    file = {
      '*.exe',
      '*.o',
      '*.a',
      '*.so',
      '*.py[co]',
      '*.sw?',
      '*.bak',
      '*.d',
      '*.idx',
      "*.lint",
      '*.gcno',
    },
  }

  resize_leaderf_window()

  vim.g.Lf_PopupShowStatusline = 0
  vim.g.Lf_PreviewInPopup = 1
  vim.g.Lf_PopupPreviewPosition = 'bottom'
  vim.g.Lf_PreviewHorizontalPosition = 'right'
  vim.g.Lf_RootMarkers = {
    'BLADE_ROOT',
    'JK_ROOT',
    'CMakeLists.txt',
    '.git',
    '.buckconfig',
    'WORKSPACE',
  }
  vim.g.Lf_WorkingDirectoryMode = 'A'
  vim.g.Lf_RememberLastSearch = 0
  vim.g.Lf_PopupColorscheme = 'walnut'
  event.on({ 'VimResized' }, {
    pattern = '*',
    callback = function()
      resize_leaderf_window()
    end,
  })
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

