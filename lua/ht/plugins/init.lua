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
      opt.setup = "require'ht.plugins." .. name .. "'.setup()"
    end
    if m.config ~= nil then
      opt.config = "require'ht.plugins." .. name .. "'.config()"
    end
    self._use(opt)

    table.insert(self.mappings, m.mappings)
  end,

  setup_mappings = function(self)
    for _, v in ipairs(self.mappings) do
      v()
    end
  end,

  append_mappings = function(self, m)
    table.insert(self.mappings, m)
  end,
}

function M.use_config(name)
  return string.format([[require 'ht.plugins.%s'.config()]], name)
end

function M.use_setup(name)
  return string.format([[require 'ht.plugins.%s'.setup()]], name)
end

function M.get_setup(name)
  return require(string.format('ht.plugins.%s', name)).mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

