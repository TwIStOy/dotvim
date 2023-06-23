local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = true,
  keys = {
    {
      "<C-t>",
    },
  },
}

M.init = function() -- code to run before plugin loaded
  vim.g.toggleterm_terminal_mapping = "<C-t>"
end

M.opts = {
  open_mapping = "<C-t>",
  hide_numbers = true,
  direction = "float",
  start_in_insert = true,
  shell = vim.o.shell,
  float_opts = { border = "rounded" },
}

return M

-- vim: et sw=2 ts=2 fdm=marker
