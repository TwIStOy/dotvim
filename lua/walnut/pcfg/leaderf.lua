module('walnut.pcfg.leaderf', package.seeall)

local set_g_var = vim.api.nvim_set_var
local get_opt = vim.api.nvim_get_option
local ftmap = require('walnut.keymap').ftmap
local keymap = vim.api.nvim_set_keymap
local cl = require('walnut.cfg.color')
local cmd = vim.api.nvim_command

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
set_g_var('Lf_PopupColorscheme', 'walnut')

vim.api.nvim_command([[au VimResized * lua require('walnut.pcfg.leaderf').resize_leaderf_window()]])

function open_project_root()
  if vim.b._dotvim_resolved_project_root ~= nil then
    vim.api.nvim_command('LeaderfFile ' .. vim.b._dotvim_resolved_project_root)
  else
    vim.api.nvim_command('LeaderfFile')
  end
end

keymap('n', '<C-p>',
       [[:lua require('walnut.pcfg.leaderf').open_project_root()<CR>]], {
         noremap = true,
         silent = true
       })
ftmap('*', 'edit-file-pwd', 'e', [[:lua require('walnut.pcfg.leaderf').open_project_root()<CR>]])

local define_hl = function(group, color_map)
  local cmd = 'highlight def ' .. group

  function default_none(key)
    if color_map[key] == nil then
      return 'NONE'
    else
      return color_map[key]
    end
  end

  local cmd = string.format('highlight def %s guifg=%s guibg=%s gui=%s ctermfg=%s ctermbg=%s cterm=%s',
    group,
    default_none('guifg'), default_none('guibg'), default_none('gui'),
    default_none('ctermfg'), default_none('ctermbg'), default_none('cterm'))
  vim.api.nvim_command(cmd)
end

function get_hl_by_name_fg(name)
  local v = vim.api.nvim_get_hl_by_name(name, 1).foreground
  if v ~= nil then
    return string.format("#%x", v)
  else
    return ''
  end
end

function get_hl_by_name_bg(name)
  local v = vim.api.nvim_get_hl_by_name(name, 1).background
  if v ~= nil then
    return string.format("#%x", v)
  else
    return ''
  end
end

function define_popup_colorscheme()
  local normal_fg     = get_hl_by_name_fg('Normal')
  local normal_bg     = get_hl_by_name_bg('Normal')

  local cursorline_bg = get_hl_by_name_bg('CursorLine')
  local error_fg      = get_hl_by_name_fg('Error')

  local incsearch_bg  = get_hl_by_name_bg('IncSearch')
  local incsearch_fg  = get_hl_by_name_fg('IncSearch')

  local keyword_fg = get_hl_by_name_fg('Keyword')

  local include_fg = get_hl_by_name_fg('Include')
  local function_fg = get_hl_by_name_fg('Function')
  local label_fg = get_hl_by_name_fg('Label')
  local constant_fg = get_hl_by_name_fg('Constant')
  local string_fg = get_hl_by_name_fg('String')


  -- Lf_hl_popup_inputText is the wincolor of input window
  define_hl('Lf_hl_popup_inputText', {
    guifg = keyword_fg,
    guibg = normal_bg,
  })

  -- Lf_hl_popup_window is the wincolor of content window
  define_hl('Lf_hl_popup_window', {
      guifg = "",
      guibg = normal_bg
    })

  -- Lf_hl_popup_blank is the wincolor of statusline window
  define_hl('Lf_hl_popup_blank', { guibg = normal_bg })

  cmd[[highlight def link Lf_hl_popup_cursor Cursor]]

  -- the color of the cursorline
  define_hl('Lf_hl_cursorline', { guifg = incsearch_fg })

  -- the color of matching character
  define_hl('Lf_hl_match', {
      guifg = string_fg,
      gui = 'bold'
    })

  -- the color of matching character in `And mode`
  define_hl('Lf_hl_match0', { guifg = include_fg, gui = 'bold' })
  define_hl('Lf_hl_match1', { guifg = function_fg, gui = 'bold' })
  define_hl('Lf_hl_match2', { guifg = label_fg, gui = 'bold' })
  define_hl('Lf_hl_match3', { guifg = constant_fg, gui = 'bold' })
  define_hl('Lf_hl_match4', { guifg = string_fg, gui = 'bold' })

  cmd[[highlight def link Lf_hl_previewTitle         Statusline]]

  cmd[[highlight def link Lf_hl_winNumber            Constant]]
  cmd[[highlight def link Lf_hl_winIndicators        Statement]]
  cmd[[highlight def link Lf_hl_winModified          String]]
  cmd[[highlight def link Lf_hl_winNomodifiable      Comment]]
  cmd[[highlight def link Lf_hl_winDirname           Directory]]
  cmd[[highlight def link Lf_hl_quickfixFileName     Directory]]
  cmd[[highlight def link Lf_hl_quickfixLineNumber   Constant]]
  cmd[[highlight def link Lf_hl_quickfixColumnNumber Constant]]
  cmd[[highlight def link Lf_hl_loclistFileName      Directory]]
  cmd[[highlight def link Lf_hl_loclistLineNumber    Constant]]
  cmd[[highlight def link Lf_hl_loclistColumnNumber  Constant]]
end

