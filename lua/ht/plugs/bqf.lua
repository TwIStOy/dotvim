module('ht.plugs.bqf', package.seeall)

function config()
  require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      auto_preview = true,
    }
  })
end
