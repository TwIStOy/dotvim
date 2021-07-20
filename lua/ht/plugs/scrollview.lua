module('ht.plugs.scrollview', package.seeall)

function setup()
  vim.g.scrollview_on_startup = 1
  vim.g.scrollview_current_only = 1
  vim.g.scrollview_auto_workarounds = 1
  vim.g.scrollview_nvim_14040_workaround = 1
end

-- vim: et sw=2 ts=2

