return {
  {
    "abecodes/tabout.nvim",
    event = { "InsertEnter" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("tabout").setup(opts)

      -- A multiline tabout setup could look like this
      vim.api.nvim_set_keymap(
        "i",
        "<M-x>",
        "<Plug>(TaboutMulti)",
        { silent = true }
      )
      vim.api.nvim_set_keymap(
        "i",
        "<M-z>",
        "<Plug>(TaboutBackMulti)",
        { silent = true }
      )
    end,
  },
}
