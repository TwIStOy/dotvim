module('walnut.pcfg.feline.config', package.seeall)

local cl = require 'walnut.cfg.color'
local u = require('utils').u
local devicons = require 'nvim-web-devicons'
-- my providers
local mp = require'walnut.pcfg.feline.providers'

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
  none = 'NONE',
}

local vi_mode_text = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    [''] = "V-BLOCK",
    V = "V-LINE",
    c = "COMMAND",
    no = "UNKNOWN",
    s = "UNKNOWN",
    S = "UNKNOWN",
    ic = "UNKNOWN",
    R = "REPLACE",
    Rv = "UNKNOWN",
    cv = "UNKWON",
    ce = "UNKNOWN",
    r = "REPLACE",
    rm = "UNKNOWN",
    t = "INSERT"
}

local vim_mode_color = {
  NORMAL = my_cl.normal,
  INSERT = my_cl.insert,
  VISUAL = my_cl.visual,
  OP = my_cl.visual,
  BLOCK = my_cl.visual,
  REPLACE = my_cl.replace,
  ['V-REPLACE'] = my_cl.replace,
  ENTER = my_cl.command,
  MORE = my_cl.command,
  SELECT = my_cl.command,
  COMMAND = my_cl.command,
  SHELL = my_cl.terminal,
  TERM = my_cl.terminal,
  NONE = my_cl.NonText,
}

local vi_mode_utils = require 'feline.providers.vi_mode'
local get_value = require('utils').get_value
local cursor = require 'feline.providers.cursor'

local component_file = {
  info = {
    provider = mp.get_current_ufn,
    hl = {
      fg = my_cl.normal,
      style = 'bold',
    },
    left_sep = ' ',
  },
  encoding = {
    provider = 'file_encoding',
    left_sep = ' ',
    hl = {
      fg = my_cl.normal,
      style = 'bold'
    }
  },
  type = {
    provider = 'file_type'
  },
  os = {
    provider = mp.file_os_info,
    left_sep = ' ',
    hl = {
      fg = my_cl.normal,
      style = 'bold'
    }
  },
  line_percentage = {
    provider = 'line_percentage',
    left_sep = ' ',
    hl = {
      style = 'bold',
    }
  },
  position = {
    provider = function()
      pos = cursor.position()
      return ' '..pos..' '
    end,
    left_sep = ' ',
    hl = {
      style = 'bold'
    }
  },
  scroll_bar = {
    provider = 'scroll_bar',
    left_sep = ' ',
    hl = {
      style = 'bold'
    }
  },
}

local component_vi_mode = {
  left = {
    provider = function()
      local current_text = ' ' .. vi_mode_text[vim.fn.mode()] .. ' '
      return current_text
    end,
    hl = function()
      local val = {
        fg = vim_mode_color[vi_mode_utils.get_vim_mode()],
        style = 'bold',
      }
      return val
    end
  }
}

local empty_component = {
  provider = function()
    return ' '
  end
}

local component_git = {
  branch = {
    provider = 'git_branch',
    icon = ' ',
    left_sep = ' ',
    hl = {
      fg = cl.get_hl_by_name_fg('Comment'),
      style = 'bold'
    },
  },
  add = {
    provider = 'git_diff_added',
    hl = {
      fg = my_cl.DiffAdd,
    }
  },
  change = {
    provider = 'git_diff_changed',
    hl = {
      fg = my_cl.DiffChange,
    }
  },
  remove = {
    provider = 'git_diff_removed',
    hl = {
      fg = my_cl.DiffDelete,
    }
  }
}

local component_coc = {
  status = {
    provider = function()
      local s = vim.g.coc_status
      if s == nil or s == '' then
        return ' '
      else
        return s
      end
    end,
    left_sep = ' ',
  },
  err = {
    provider = mp.diagnostic_errors,
    enabled = function()
      return mp.get_diagnostics_count('error') > 0
    end,
    hl = {
      fg = my_cl.DiffDelete
    }
  },
  warning = {
    provider = mp.diagnostic_warnings,
    enabled = function()
      return mp.get_diagnostics_count('warning') > 0
    end,
    hl = {
      fg = my_cl.DiffChange
    }
  }
}

local components = {
  left = {
    active = {
      component_vi_mode.left,
      component_coc.status,
      component_coc.err,
      component_coc.warning,
    },
    inactive = {
      component_vi_mode.left,
      empty_component,
    },
  },
  mid = {
    active = {
      component_file.info,
    },
    inactive = {
      component_file.info,
    },
  },
  right = {
    active = {
      component_git.add,
      component_git.change,
      component_git.remove,
      component_file.os,
      component_git.branch,
      component_file.line_percentage,
      component_file.position,
    },
    inactive = {
      component_git.add,
      component_git.change,
      component_git.remove,
      component_file.position,
    },
  }
}

local properties = {
  force_inactive = {
    filetypes = {
      'NvimTree',
      'dbui',
      'packer',
      'startify',
      'fugitive',
      'fugitiveblame'
    },
    buftypes = {'terminal'},
    bufnames = {}
  }
}

require'feline'.setup {
  default_bg = my_cl.bg,
  default_fg = my_cl.normal,
  components = components,
  properties = properties,
}
