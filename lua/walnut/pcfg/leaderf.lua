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

function define_popup_colorscheme()
  -- Lf_hl_popup_inputText is the wincolor of input window
  define_hl('Lf_hl_popup_inputText', {
    guifg = cl.visual,
    guibg = cl.bg1,
  })

  -- Lf_hl_popup_window is the wincolor of content window
  define_hl('Lf_hl_popup_window', {
      guifg = cl.normal,
      guibg = cl.bg
    })

  -- Lf_hl_popup_blank is the wincolor of statusline window
  define_hl('Lf_hl_popup_blank', { guibg = cl.bg })

  cmd[[highlight def link Lf_hl_popup_cursor Cursor]]

  -- the color of the cursorline
  define_hl('Lf_hl_cursorline', { guifg = cl.yellow_bright })

  -- the color of matching character
  define_hl('Lf_hl_match', {
      guifg = cl.green_bright,
      gui = 'bold'
    })

  -- the color of matching character in `And mode`
  define_hl('Lf_hl_match0', { guifg = cl.green_bright, gui = 'bold' })
  define_hl('Lf_hl_match1', { guifg = cl.red_bright, gui = 'bold' })
  define_hl('Lf_hl_match2', { guifg = cl.command, gui = 'bold' })
  define_hl('Lf_hl_match3', { guifg = cl.orange_bright, gui = 'bold' })
  define_hl('Lf_hl_match4', { guifg = cl.purple_bright, gui = 'bold' })

-- " highlight def Lf_hl_popup_prompt guifg=#ffcd4a guibg=NONE gui=NONE ctermfg=221 ctermbg=NONE cterm=NONE
-- " highlight def Lf_hl_popup_spin guifg=#e6e666 guibg=NONE gui=NONE ctermfg=185 ctermbg=NONE cterm=NONE
-- " highlight def Lf_hl_popup_normalMode guifg=#333300 guibg=#c1ce96 gui=bold ctermfg=58 ctermbg=187 cterm=bold
-- " highlight def Lf_hl_popup_inputMode guifg=#003333 guibg=#98b3a5 gui=bold ctermfg=23 ctermbg=109 cterm=bold
-- " highlight def Lf_hl_popup_category guifg=#ecebf0 guibg=#636769 gui=NONE ctermfg=255 ctermbg=241 cterm=NONE
-- " highlight def Lf_hl_popup_nameOnlyMode guifg=#14212b guibg=#cbb370 gui=NONE ctermfg=234 ctermbg=179 cterm=NONE
-- " highlight def Lf_hl_popup_fullPathMode guifg=#14212b guibg=#aab3b6 gui=NONE ctermfg=234 ctermbg=249 cterm=NONE
-- " highlight def Lf_hl_popup_fuzzyMode guifg=#14212b guibg=#aab3b6 gui=NONE ctermfg=234 ctermbg=249 cterm=NONE
-- " highlight def Lf_hl_popup_regexMode guifg=#14212b guibg=#a0b688 gui=NONE ctermfg=234 ctermbg=108 cterm=NONE
-- " highlight def Lf_hl_popup_cwd guifg=#f2ebc7 guibg=#6e7476 gui=NONE ctermfg=230 ctermbg=243 cterm=NONE
-- " highlight def Lf_hl_popup_lineInfo guifg=#353129 guibg=#dce6da gui=NONE ctermfg=236 ctermbg=254 cterm=NONE
-- " highlight def Lf_hl_popup_total guifg=#353129 guibg=#b8ccbb gui=NONE ctermfg=236 ctermbg=151 cterm=NONE
-- "
-- "
-- " " the color of matching character in nameOnly mode when ';' is typed
-- " highlight def Lf_hl_matchRefine gui=bold guifg=Magenta cterm=bold ctermfg=201
-- "
-- " " the color of help in normal mode when <F1> is pressed
-- " highlight def link Lf_hl_help               Comment
-- " highlight def link Lf_hl_helpCmd            Identifier
-- "
-- " " the color when select multiple lines
-- " highlight def Lf_hl_selection guifg=Black guibg=#a5eb84 gui=NONE ctermfg=Black ctermbg=156 cterm=NONE
-- "
-- " " the color of `Leaderf buffer`
-- " highlight def link Lf_hl_bufNumber          Constant
-- " highlight def link Lf_hl_bufIndicators      Statement
-- " highlight def link Lf_hl_bufModified        String
-- " highlight def link Lf_hl_bufNomodifiable    Comment
-- " highlight def link Lf_hl_bufDirname         Directory
-- "
-- " " the color of `Leaderf tag`
-- " highlight def link Lf_hl_tagFile            Directory
-- " highlight def link Lf_hl_tagType            Type
-- "
-- " highlight def link Lf_hl_tagKeyword         Keyword
-- " " the color of `Leaderf bufTag`
-- " highlight def link Lf_hl_buftagKind         Title
-- " highlight def link Lf_hl_buftagScopeType    Keyword
-- " highlight def link Lf_hl_buftagScope        Type
-- " highlight def link Lf_hl_buftagDirname      Directory
-- " highlight def link Lf_hl_buftagLineNum      Constant
-- " highlight def link Lf_hl_buftagCode         Comment
-- "
-- " " the color of `Leaderf function`
-- " highlight def link Lf_hl_funcKind           Title
-- " highlight def link Lf_hl_funcReturnType     Type
-- " highlight def link Lf_hl_funcScope          Keyword
-- " highlight def link Lf_hl_funcName           Function
-- " highlight def link Lf_hl_funcDirname        Directory
-- " highlight def link Lf_hl_funcLineNum        Constant
-- "
-- " " the color of `Leaderf line`
-- " highlight def link Lf_hl_lineLocation       Comment
-- "
-- " " the color of `Leaderf self`
-- " highlight def link Lf_hl_selfIndex          Constant
-- " highlight def link Lf_hl_selfDescription    Comment
-- "
-- " " the color of `Leaderf help`
-- " highlight def link Lf_hl_helpTagfile        Comment
-- "
-- " " the color of `Leaderf rg`
-- " highlight def link Lf_hl_rgFileName         Directory
-- " highlight def link Lf_hl_rgLineNumber       Constant
-- " " the color of line number if '-A' or '-B' or '-C' is in the options list
-- " " of `Leaderf rg`
-- " highlight def link Lf_hl_rgLineNumber2      Folded
-- " " the color of column number if '--column' in g:Lf_RgConfig
-- " highlight def link Lf_hl_rgColumnNumber     Constant
-- " highlight def Lf_hl_rgHighlight guifg=#000000 guibg=#cccc66 gui=NONE ctermfg=16 ctermbg=185 cterm=NONE
-- "
-- " " the color of `Leaderf gtags`
-- " highlight def link Lf_hl_gtagsFileName      Directory
-- " highlight def link Lf_hl_gtagsLineNumber    Constant
-- " highlight def Lf_hl_gtagsHighlight guifg=#000000 guibg=#cccc66 gui=NONE ctermfg=16 ctermbg=185 cterm=NONE

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

