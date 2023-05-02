local M = {
  "onsails/lspkind.nvim",
  lazy = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

M.config = function()
  local lspkind = require("lspkind")

  lspkind.init {
    mode = "symbol_text",

    symbol_map = {
      Array = "",
      Boolean = "",
      Class = "",
      Color = "",
      Constant = "",
      Constructor = "",
      Enum = "",
      EnumMember = "",
      Event = "",
      Field = "",
      File = "",
      Folder = "",
      Function = "",
      Interface = "",
      Key = "",
      Keyword = "",
      Method = "",
      Module = "",
      Namespace = "",
      Null = "",
      Number = "",
      Object = "",
      Operator = "",
      Package = "",
      Property = "",
      Reference = "",
      Snippet = "",
      String = "",
      Struct = "",
      Text = "",
      TypeParameter = "",
      Unit = "",
      Value = "",
      Variable = "",
      Copilot = "",
      Codeium = "",
      Math = "󰀫",
    },
  }
end

return M
