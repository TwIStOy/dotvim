module('ht.plugs.nightfox', package.seeall)

function config()
  vim.g.nightfox_style = "nordfox"
  vim.g.nightfox_italic_variables = true
  vim.g.nightfox_italic_functions = true

  require('nightfox').set()
end

-- vim: et sw=2 ts=2

