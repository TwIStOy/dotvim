local M = {}

M.core = { 'skywind3000/vim-quickui', fn = { 'quickui#*' } }

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
local function update_color()
  hi {
    QuickBG = { guifg = foreground('Normal'), guibg = background('Normal') },
    QuickSel = {
      gui = 'bold',
      guibg = background('IncSearch'),
      guifg = foreground('IncSearch'),
    },
    QuickOff = { guifg = background('CursorLine') },
  }
end

M.setup = function() -- code to run before plugin loaded
  local event = require 'ht.core.event'

  vim.g.quickui_border_style = 2
  vim.g.quickui_show_tip = 1

  event.on('ColorScheme', {
    pattern = '*',
    callback = function()
      update_color()
    end,
  })
end

M.config = function() -- code to run after plugin loaded
  update_color()
end

M.open_dropbox = function(ft)
  local dropbox = require 'ht.core.dropbox'

  local context = dropbox.setup(ft)
  if #context == 0 then
    return
  end

  local current_cursor = 0
  if vim.g['quickui#context#cursor'] ~= nil then
    current_cursor = vim.g['quickui#context#cursor']
  end

  local opts = { index = current_cursor }
  vim.api.nvim_call_function('quickui#context#open', { context, opts })
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

