---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    {
      "TwIStOy/tree-sitter-pidl",
      url = "git@github.com:TwIStOy/tree-sitter-pidl.git",
    },
    {
      "TwIStOy/tree-sitter-kafel",
      url = "git@github.com:TwIStOy/tree-sitter-kafel.git",
    },
  },
  opts = {},
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        -- add parsers
        require("nvim-treesitter.parsers").pidl = {
          install_info = {
            path = DOTVIM_lazy_root .. "/tree-sitter-pidl",
            generate = false,
          },
        }
        require("nvim-treesitter.parsers").kafel = {
          install_info = {
            path = DOTVIM_lazy_root .. "/tree-sitter-kafel",
            generate = false,
          },
        }
      end,
    })
  end,
}
