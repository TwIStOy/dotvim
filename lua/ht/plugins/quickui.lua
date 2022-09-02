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

local function color_value(v)
  if type(v) == 'string' then
    return v
  end
  if type(v) == 'number' then
    return string.format('#%x', v)
  end
  return ''
end

local function hi(groups, default)
  for group_name, highlights in pairs(groups) do
    local options = {}
    for k, v in pairs(highlights) do
      if v ~= nil then
        table.insert(options, string.format("%s=%s", k, color_value(v)))
      end
    end

    if #options > 0 then
      vim.cmd(string.format("highlight %s %s %s", default and "default" or "",
                            group_name, table.concat(options, ' ')))
    end
  end
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

local open_dropbox = function(ft)
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
  local mapping = require 'ht.core.mapping'
  mapping.map {
    keys = { ';', ';' },
    action = function()
      open_dropbox(vim.api.nvim_buf_get_var(0, '&ft'))
    end,
    desc = 'open-dropbox'
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

