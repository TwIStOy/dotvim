local M = {}

M.core = { 'kevinhwang91/nvim-bqf', ft = 'qf' }

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require'bqf'.setup {
    auto_enable = true,
    auto_resize_height = false,
    preview = { auto_preview = true },
    func_map = { tab = '' },
  }
end

M.mappings = function() -- code for mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

