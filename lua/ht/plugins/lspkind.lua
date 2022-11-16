local M = {}

M.core = {
  'onsails/lspkind.nvim',
  module = { 'lspkind' },
  event = { 'BufReadPre' },
}

M.setup = function() -- code to run before plugin loaded
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

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

