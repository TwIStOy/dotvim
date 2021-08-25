module('ht.plugs.quickui', package.seeall)

local cmd = vim.api.nvim_command
local vcall = vim.api.nvim_call_function
local dropdown = require 'ht.core.dropdown'
local hi = require('ht.core.vim').HighlightGroups

local context_registers = {}

--[[
Background color of given highlight group
--]]
local function background(hi)
  return vim.api.nvim_get_hl_by_name(hi, 1).background
end

--[[
Foreground color of given highlight group
--]]
local function foreground(hi)
  return vim.api.nvim_get_hl_by_name(hi, 1).foreground
end

--[[
Update Quickui's highlight colors.
- Before any window displays
- After new colorscheme is loaded.
--]]
function update_color()
  hi {
    QuickBG = {guifg = foreground('Normal'), guibg = background('Normal')},
    QuickSel = {
      gui = 'bold',
      guibg = background('IncSearch'),
      guifg = foreground('IncSearch')
    },
    QuickOff = {guifg = background('CursorLine')}
  }
end

function setup()
  vim.g.quickui_border_style = 2
  vim.g.quickui_show_tip = 1
  cmd [[au ColorScheme * lua require("ht.plugs.quickui").update_color()]]
end

function config()
  update_color()
end

function OpenDropdown(ft)
  local context = dropdown.PrepareContext(ft)
  if #context == 0 then
    require('notify')('No Dropdown-Menu Item!', 'Error')
    return
  end

  local current_cursor = 0
  if vim.g['quickui#context#cursor'] ~= nil then
    current_cursor = vim.g['quickui#context#cursor']
  end

  local opts = {index = current_cursor}
  vcall('quickui#context#open', {context, opts})
end

-- vim: et sw=2 ts=2

