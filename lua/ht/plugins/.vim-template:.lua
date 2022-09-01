local M = {}

M.core = {
  %HERE%
}

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
  return {
    default = { -- pass to vim.api.nvim_set_keymap
    },
    wk = { -- send to which-key
    }
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

