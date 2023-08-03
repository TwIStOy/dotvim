return {
  -- toggle code comments
  {
    "tomtom/tcomment_vim",
    enabled = false,
    event = "BufReadPost",
    init = function()
      vim.g.tcomment_maps = 0
    end,
    keys = {
      { "gcc", "<cmd>TComment<CR>", desc = "toggle-comment" },
      { "gcc", ":TCommentBlock<CR>", mode = "v", desc = "toggle-comment" },
    },
  },
}
