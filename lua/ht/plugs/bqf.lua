module('ht.plugs.bqf', package.seeall)

function config()
  require('bqf').setup({
    auto_enable = true,
    auto_resize_height = false,
    preview = {
      auto_preview = true,
    },
    func_map = {
      tab = '',
    }
  })
end

