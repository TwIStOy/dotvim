module('ht.plugs.newpaper', package.seeall)

function config()
  local style = 'light'
  require('newpaper').setup {
    style = style,
    lualine_style = style,
    colors = {
      cursor = 'diffchange_bg'
    }
  }
end

-- vim: et sw=2 ts=2

