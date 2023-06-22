return {
  -- vim-surround
  {
    "tpope/vim-surround",
    event = "BufReadPost",
    init = function()
      vim.g.surround_no_mappings = 0
      vim.g.surround_no_insert_mappings = 1
    end,
  },
}
