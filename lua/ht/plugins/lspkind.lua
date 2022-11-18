local M = {}

M.core = {
  'onsails/lspkind.nvim',
  module = { 'lspkind' },
  event = { 'BufReadPre' },
}

M.config = function() -- code to run after plugin loaded
  local lspkind = require 'lspkind'

  lspkind.init {
    mode = 'symbol_text',

    symbol_map = {
      Text = " ",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = " ",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = " ",
      Copilot = "",
    },
  }
end

return M
-- vim: et sw=2 ts=2 fdm=marker

