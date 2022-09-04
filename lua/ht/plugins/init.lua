local M = {}

M.loader = {
  mappings = {},

  _use = function()
  end,

  new = function(self, use)
    local new_obj = vim.deepcopy(self)
    new_obj._use = use
    return new_obj
  end,

  setup = function(self, name)
    local m = require('ht.plugins.' .. name)
    local opt = m.core
    if m.setup ~= nil then
      opt.setup = "require'ht.plugins."..name.."'.setup()"
    end
    if m.config ~= nil then
      opt.config = "require'ht.plugins."..name.."'.config()"
    end
    self._use(opt)

    table.insert(self.mappings, m.mappings)
  end,

  setup_mappings = function(self)
    for _, v in ipairs(self.mappings) do
      v()
    end
  end,
}

return M
-- vim: et sw=2 ts=2 fdm=marker

