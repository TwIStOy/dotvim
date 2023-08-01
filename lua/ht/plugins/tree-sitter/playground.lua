return {
  Use {
    "nvim-treesitter/playground",
    lazy = {
      lazy = true,
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
    functions = {
      {
        filter = {
          ---@param buffer VimBuffer
          filter = function(buffer)
            return #buffer.ts_highlights > 0
          end,
        },
        values = {
          FuncSpec("Toggle tree-sitter playground", "TSPlaygroundToggle"),
        },
      },
    },
  },
}
