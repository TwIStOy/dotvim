module('ht.plugs.nvim_context_vt', package.seeall)
local u = require('utils').u

function config()
  local ts_utils = require "nvim-treesitter.ts_utils"

  local black_table = {['arguments'] = true}

  require('nvim_context_vt').setup({
    custom_text_handler = function(node)
      if black_table[node:type()] then return nil end
      local srow, scolumn, erow, ecolumn = node:range()
      local row = vim.api.nvim_win_get_cursor(0)
      if srow == erow and srow == row[1] - 1 then return nil end

      return u'2191' .. " " .. ts_utils.get_node_text(node)[1]
    end
  })
end

-- vim: et sw=2 ts=2

