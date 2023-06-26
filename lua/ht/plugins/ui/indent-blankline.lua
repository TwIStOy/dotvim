return {
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = function() -- code to run after plugin loaded
      return {
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        context_highlight_list = { "IndentBlanklineIndent3" },
        context_char_list = { "▏" },
        char = "",

        bufname_exclude = { "" },
        filetype_exclude = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
        },
      }
    end,
  },
}
