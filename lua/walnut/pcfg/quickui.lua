module('walnut.pcfg.quickui', package.seeall)

local va = vim.api
local cmd = vim.api.nvim_command
local keymap = va.nvim_set_keymap
local setopt = va.nvim_set_option

local cl = require('walnut.cfg.color')

vim.g.quickui_border_style = 2

function update_color()
  local normal_bg = vim.api.nvim_get_hl_by_name('Normal', 1).background
  local normal_fg = vim.api.nvim_get_hl_by_name('Normal', 1).foreground
  local cursorline_bg = vim.api.nvim_get_hl_by_name('CursorLine', 1).background
  local error_bg = vim.api.nvim_get_hl_by_name('Error', 1).background
  local error_fg = vim.api.nvim_get_hl_by_name('Error', 1).foreground
  local incsearch_bg = vim.api.nvim_get_hl_by_name('IncSearch', 1).background
  local incsearch_fg = vim.api.nvim_get_hl_by_name('IncSearch', 1).foreground

  cmd(string.format([[hi! QuickBG guifg=%s guibg=%s]], normal_bg, normal_bg))
  cmd(string.format([[hi! QuickKey gui=bold guifg=#%x]], error_bg))
  cmd(string.format([[hi! QuickSel gui=bold guibg=#%x guifg=#%x]], incsearch_bg, incsearch_fg))
  cmd(string.format([[hi! QuickOff guifg=%s]], cl.cursorline_bg))
end

function install_default_menu_items()
  vim.api.nvim_call_function('quickui#menu#install', {
    '&File', {
      { '&Open File', [[lua require('walnut.pcfg.leaderf').open_project_root()]]},
      { 'File &Explorer', [[lua require('walnut.window').fast_forward_to_file_explorer()]] },
      { '--', '' },
      { '&Save', 'update' },
      { 'Save all', 'wa' },
    }
  })
end

local context_menu = {}

function inspect()
  print(vim.inspect(context_menu))
end

function append_context_menu_section(ft, section)
  -- print('Append', ft, 'section:', vim.inspect(section))

  if context_menu[ft] == nil then
    context_menu[ft] = {}
  end

  table.insert(context_menu[ft], section)
end

function open_top_menu()
  update_color()

  vim.api.nvim_call_function('quickui#menu#open', {})
end

function open_dropdown_menu(ft)
  update_color()

  local res = {}

  if context_menu['*'] ~= nil then
    vim.list_extend(res, context_menu['*'])
  end

  if context_menu[ft] ~= nil then
    for i,v in ipairs(context_menu[ft]) do
      if #res > 0 then
        vim.list_extend(res, {'-'})
      end
      vim.list_extend(res, v)
    end
  end

  local current_cursor = 0
  if vim.g['quickui#context#cursor'] ~= nil then
    current_cursor = vim.g['quickui#context#cursor']
  end

  local opts = { index = current_cursor }
  if #res == 0 then
    print('No Context Menu Item!')
  else
    vim.api.nvim_call_function('quickui#context#open', { res, opts })
  end
end

