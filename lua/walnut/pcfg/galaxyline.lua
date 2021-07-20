local gl = require 'galaxyline'
local fileinfo = require 'galaxyline.provider_fileinfo'
local devicons = require 'nvim-web-devicons'
local gls = gl.section
local cl = require 'walnut.cfg.color'

local u = require('utils').u

local my_cl = {
  bg = cl.get_hl_by_name_bg('CursorLine'),
  normal = cl.get_hl_by_name_fg('Normal'),
  insert = cl.get_hl_by_name_fg('Comment'),
  replace = cl.get_hl_by_name_fg('ErrorMsg'),
  visual = cl.get_hl_by_name_fg('DiffAdd'),
  command = cl.get_hl_by_name_fg('DiffChange'),
  terminal = cl.get_hl_by_name_fg('DiffDelete'),
  DiffAdd = cl.get_hl_by_name_fg('DiffAdd'),
  DiffChange = cl.get_hl_by_name_fg('DiffChange'),
  DiffDelete = cl.get_hl_by_name_fg('DiffDelete'),
  NonText = cl.get_hl_by_name_fg('NonText'),
  MoreMsg = cl.get_hl_by_name_fg('MoreMsg'),
  MatchParen = cl.get_hl_by_name_fg('MatchParen'),
  none = 'NONE'
}

local mode_map = {
  ['n'] = {'NORMAL', my_cl.normal},
  ['i'] = {'INSERT', my_cl.insert},
  ['R'] = {'REPLACE', my_cl.replace},
  ['v'] = {'VISUAL', my_cl.visual},
  ['V'] = {'V-LINE', my_cl.visual},
  [''] = {'V-BLOCK', my_cl.visual},
  ['c'] = {'COMMAND', my_cl.command},
  ['s'] = {'SELECT', my_cl.visual},
  ['S'] = {'S-LINE', my_cl.visual},
  ['t'] = {'TERMINAL', my_cl.terminal},
  ['Rv'] = {'VIRTUAL'},
  ['rm'] = {'--MORE'}
}

local sep = {
  right_filled = u 'e0b2',
  left_filled = u 'e0b0',
  -- right = u '2503',
  -- left = u '2503',
  right = u 'e0b3',
  left = u 'e0b1'
}

local icons = {
  locker = u 'f023',
  unsaved = u 'f693',
  dos = u 'e70f',
  unix = u 'f17c',
  mac = u 'f179',
  lsp_warn = u 'f071',
  lsp_error = u 'f46e'
}

local function mode_label() return mode_map[vim.fn.mode()][1] or 'N/A' end

local function mode_hl()
  return (mode_map[vim.fn.mode()] and mode_map[vim.fn.mode()][2]) or my_cl.none
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
      highlight('GalaxyViMode', modehl, my_cl.bg)
      highlight('GalaxyViModeInv', my_cl.bg, modehl)
      return "     "
    end
  }
}

gls.left[2] = {
  CocStatus = {
    provider = function()
      local s = vim.api.nvim_call_function('coc#status', {})
      if s == '' then
        return u 'e780'
      else
        return s
      end
    end,
    separator = " ",
    separator_highlight = {my_cl.normal, my_cl.bg},
    highlight = {my_cl.MatchParen, my_cl.bg}
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
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color, my_cl.bg
    }
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
    highlight = {my_cl.normal, my_cl.bg},
    separator = ' ',
    separator_highlight = {my_cl.normal, my_cl.bg}
  }
}

gls.right[1] = {
  GitIcon = {
    provider = function() return " " end,
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    highlight = {my_cl.MoreMsg, my_cl.bg}
  }
}

gls.right[2] = {
  GitBranch = {
    provider = "GitBranch",
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    separator = "",
    separator_highlight = {my_cl.none, my_cl.bg},
    highlight = {my_cl.MoreMsg, my_cl.bg, "bold"}
  }
}

gls.right[3] = {
  DiffAdd = {
    provider = "DiffAdd",
    condition = wide_enough,
    separator = ' ',
    icon = " ",
    highlight = {my_cl.DiffAdd, my_cl.bg},
    separator_highlight = {my_cl.none, my_cl.bg}
  }
}

gls.right[4] = {
  DiffModified = {
    provider = "DiffModified",
    condition = wide_enough,
    icon = "柳",
    highlight = {my_cl.DiffChange, my_cl.bg}
  }
}

gls.right[5] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = wide_enough,
    icon = " ",
    highlight = {my_cl.DiffDelete, my_cl.bg}
  }
}

gls.right[6] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " ",
    separator_highlight = {my_cl.normal, my_cl.bg},
    highlight = {my_cl.normal, my_cl.bg}
  }
}

gls.right[7] = {
  FileSize = {
    provider = "FileSize",
    separator = " ",
    condition = buffer_not_empty,
    separator_highlight = {my_cl.normal, my_cl.bg},
    highlight = {my_cl.normal, my_cl.bg}
  }
}

for k, v in pairs(gls.left) do gls.short_line_left[k] = v end
table.remove(gls.short_line_left, 1)
table.remove(gls.short_line_left, 1)

for k, v in pairs(gls.right) do gls.short_line_right[k] = v end
table.remove(gls.short_line_right, 1)
table.remove(gls.short_line_right, 1)
table.remove(gls.short_line_right)
table.remove(gls.short_line_right)

