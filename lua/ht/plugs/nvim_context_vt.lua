module('ht.plugs.nvim_context_vt', package.seeall)

function config()
  require('nvim_context_vt').setup({
    custom_text_handler = function(node)
      if node:type() == 'function' then return nil end
      return ts_utils.get_node_text(node)[1]
    end
  })
end

-- vim: et sw=2 ts=2

