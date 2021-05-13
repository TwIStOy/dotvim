local gl = require 'galaxyline'
local fileinfo = require 'galaxyline.provider_fileinfo'
local devicons = require 'nvim-web-devicons'
local gls = gl.section
local cl = require 'walnut.cfg.color'

local u = require('utils').u

local mode_map = {
  ['n'] = { 'NORMAL', cl.normal },
  ['i'] = { 'INSERT', cl.insert },
  ['R'] = { 'REPLACE', cl.replace },
  ['v'] = { 'VISUAL', cl.visual },
  ['V'] = { 'V-LINE', cl.visual },
  [''] = { 'V-BLOCK', cl.visual },
  ['c'] = { 'COMMAND', cl.command },
  ['s'] = { 'SELECT', cl.visual },
  ['S'] = { 'S-LINE', cl.visual },
  ['t'] = { 'TERMINAL', cl.terminal },
  ['Rv'] = { 'VIRTUAL' },
  ['rm'] = { '--MORE' },
}

local sep = {
  right_filled = u 'e0b2',
  left_filled = u 'e0b0',
  -- right = u '2503',
  -- left = u '2503',
  right = u 'e0b3',
  left = u 'e0b1',
}

local icons = {
  locker = u 'f023',
  unsaved = u 'f693',
  dos = u 'e70f',
  unix = u 'f17c',
  mac = u 'f179',
  lsp_warn = u 'f071',
  lsp_error = u 'f46e',
}

local function mode_label()
  return mode_map[vim.fn.mode()][1] or 'N/A'
end

local function mode_hl()
  return (mode_map[vim.fn.mode()] and mode_map[vim.fn.mode()][2]) or cl.none
end

local function highlight(group, fg, bg, gui)
  local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)
  if gui ~= nil then cmd = cmd .. ' gui=' .. gui end
  vim.cmd(cmd)
end

local function buffer_not_empty()
  if vim.fn.empty(vim.fn.expand '%:t') ~= 1 then return true end
  return false
end

local function wide_enough()
  local squeeze_width = vim.fn.winwidth(0)
  if squeeze_width > 80 then return true end
  return false
end

gls.left[1] = {
  ViMode = {
    provider = function()
      local modehl = mode_hl()
      highlight('GalaxyViMode', modehl, cl.bg)
      highlight('GalaxyViModeInv', cl.bg, modehl)
      return "     "
    end,
  },
}

gls.left[2] = {
  CocStatus = {
    provider = function()
      return vim.api.nvim_call_function('coc#status', {})
    end,
    separator = " ",
    separator_highlight = {cl.normal, cl.bg},
    highlight = {cl.green_bright, cl.bg}
  }
}

gls.left[3] = {
  FileIcon = {
    provider = function()
      local fname, ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
      local icon, iconhl = devicons.get_icon(fname, ext)
      if icon == nil then return '' end
      return ' ' .. icon .. '  '
    end,
    condition = buffer_not_empty,
    highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, cl.bg},
  }
}

gls.left[4] = {
  FileName = {
    provider = function()
      if not buffer_not_empty() then return '' end
      local fname
      if wide_enough() then
        fname = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.')
      else
        fname = vim.fn.expand '%:t'
      end
      if #fname == 0 then return '' end
      if vim.bo.readonly then fname = fname .. ' ' .. icons.locker end
      if vim.bo.modified then fname = fname .. ' ' .. icons.unsaved end
      return ' ' .. fname .. ' '
    end,
    highlight = {cl.fg, cl.bg},
    separator = ' ',
    separator_highlight = {cl.normal, cl.bg},
  },
}

gls.right[1] = {
  GitIcon = {
    provider = function()
      return " "
    end,
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    highlight = {cl.yellow_bright, cl.bg}
  }
}

gls.right[2] = {
  GitBranch = {
    provider = "GitBranch",
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    separator = "",
    separator_highlight = {cl.none, cl.bg},
    highlight = {cl.yellow_bright, cl.bg, "bold"}
  }
}

gls.right[3] = {
  DiffAdd = {
    provider = "DiffAdd",
    condition = wide_enough,
    separator = ' ',
    icon = " ",
    highlight = {cl.green_bright, cl.bg},
    separator_highlight = {cl.none, cl.bg},
  }
}

gls.right[4] = {
  DiffModified = {
    provider = "DiffModified",
    condition = wide_enough,
    icon = "柳",
    highlight = {cl.yellow_bright, cl.bg}
  }
}

gls.right[5] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = wide_enough,
    icon = " ",
    highlight = {cl.red_bright, cl.bg}
  }
}

gls.right[6] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " ",
    separator_highlight = {cl.normal, cl.bg},
    highlight = {cl.white_bright, cl.bg}
  }
}

gls.right[7] = {
  FileSize = {
    provider = "FileSize",
    separator = " ",
    condition = buffer_not_empty,
    separator_highlight = {cl.normal, cl.bg},
    highlight = {cl.white_bright, cl.bg}
  }
}

for k, v in pairs(gls.left) do
  gls.short_line_left[k] = v
end
table.remove(gls.short_line_left, 1)

for k, v in pairs(gls.right) do
  gls.short_line_right[k] = v
end
table.remove(gls.short_line_right, 1)
table.remove(gls.short_line_right, 1)
table.remove(gls.short_line_right)
table.remove(gls.short_line_right)


