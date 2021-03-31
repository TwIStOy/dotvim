module('walnut.pcfg.leaderf', package.seeall)

local set_g_var = vim.api.nvim_set_var
local get_opt = vim.api.nvim_get_option
local ftmap = require('walnut.keymap').ftmap
local keymap = vim.api.nvim_set_keymap

set_g_var('Lf_ShortcutF', '<Leader>ff')
set_g_var('Lf_ShortcutB', '<Leader>ffb')
set_g_var('Lf_WindowPosition', 'popup')
set_g_var('Lf_RecurseSubmodules', 1)

set_g_var('Lf_HideHelp', 1)
set_g_var('Lf_UseVersionControlTool', 0)
set_g_var('Lf_DefaultExternalTool', '')
set_g_var('Lf_WorkingDirectoryMode', 'ac')
set_g_var('Lf_PopupPosition', { 1, 0 })
set_g_var('Lf_FollowLinks', 1)
set_g_var('Lf_WildIgnore', {
  dir = {
    '.git', '.svn', '.hg', '.cache', '.build',
    '.deps', '.third-party-build', 'build'
  },
  file = {
    '*.exe', '*.o', '*.a', '*.so', '*.py[co]',
    '*.sw?', '*.bak', '*.d', '*.idx', "*.lint",
    '*.gcno',
  }
})

function resize_leaderf_window()
  set_g_var('Lf_PopupWidth', get_opt('columns') * 3 / 4)
  set_g_var('Lf_PopupHeight', math.floor(get_opt('lines') * 0.6))
end

resize_leaderf_window()
set_g_var('Lf_PopupShowStatusline', 0)
set_g_var('Lf_PreviewInPopup', 1)
set_g_var('Lf_PopupPreviewPosition', 'bottom')
set_g_var('Lf_PreviewHorizontalPosition', 'right')
set_g_var('Lf_RootMarkers', {
  'BLADE_ROOT', 'JK_ROOT', 'CMakeLists.txt', '.git'
})
set_g_var('Lf_WorkingDirectoryMode', 'A')
set_g_var('Lf_RememberLastSearch', 0)

vim.api.nvim_command([[au VimResized * lua require('walnut.pcfg.leaderf').resize_leaderf_window()]])

function open_project_root()
  if vim.b._resolved_project_root ~= nil then
    vim.api.nvim_command('LeaderfFile ' .. vim.b._resolved_project_root)
  else
    vim.api.nvim_command('LeaderfFile')
  end
end

keymap('n', '<C-r>',
       [[:lua require('walnut.pcfg.leaderf').open_project_root()<CR>]], {
         noremap = true,
         silent = true
       })
ftmap('*', 'edit-file-pwd', 'e', [[:lua require('walnut.pcfg.leaderf').open_project_root()<CR>]])

