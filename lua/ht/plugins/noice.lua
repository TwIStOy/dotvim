local M = {}

M.core = {
  "folke/noice.nvim",
  requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
}

M.config = function() -- code to run after plugin loaded
  require('noice').setup {
    lsp = {
      signature = { enabled = false, auto_open = false },
      hover = { enabled = false },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

