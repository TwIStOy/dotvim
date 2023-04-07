local M = {
  'onsails/lspkind.nvim',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

M.config = function()
  local lspkind = require 'lspkind'

  local icons = require'nvim-web-devicons'.get_icons()

  lspkind.init {
    mode = 'symbol_text',

    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = icons.erb.icon,
      Copilot = "",
    },
  }
end

return M
