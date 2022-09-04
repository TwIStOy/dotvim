local M = {}

M.core = { "folke/which-key.nvim", opt = false }

M.config = function() -- code to run after plugin loaded
  require("which-key").setup {
    key_labels = { ["<space>"] = "SPC", ["<cr>"] = "RET", ["<tab>"] = "TAB" },
    layout = { align = 'center' },
  }
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

