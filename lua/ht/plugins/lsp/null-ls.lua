return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local builtins = null_ls.builtins
      local Const = require("ht.core.const")
      local lsp_conf = require("ht.conf.lsp.init")

      local sources = {}

      for _, tool in ipairs(lsp_conf.all_tools) do
        local opt = {}
        if tool.mason_pkg == nil then
          opt.command = Const.mason_bin .. "/" .. tool.name
        elseif tool.mason_pkg ~= false then
          opt.command = Const.mason_bin .. "/" .. tool.mason_pkg
        end
        if tool.opts ~= nil then
          opt = vim.tbl_extend("force", opt, tool.opts)
        end
        sources[#sources + 1] = builtins[tool.typ][tool.name].with(opt)
      end
      sources[#sources + 1] = builtins.formatting.dart_format

      null_ls.setup {
        sources = sources,
      }
    end,
  },
}
