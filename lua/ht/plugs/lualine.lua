module('ht.plugs.lualine', package.seeall)

function config()
  require'lualine'.setup {
    options = options,
    sections = sections,
    inactive_sections = inactive_sections,
    tabline = {},
    extensions = {}
  }
end

-- vim: et sw=2 ts=2

