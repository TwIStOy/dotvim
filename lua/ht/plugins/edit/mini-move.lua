return {
  {
    "echasnovski/mini.move",
    keys = {
      { "<C-h>", nil, mode = { "n", "v" } },
      { "<C-j>", nil, mode = { "n", "v" } },
      { "<C-k>", nil, mode = { "n", "v" } },
      { "<C-l>", nil, mode = { "n", "v" } },
    },
    opts = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "<C-h>",
      right = "<C-l>",
      down = "<C-j>",
      up = "<C-k>",

      -- Move current line in Normal mode
      line_left = "<C-h>",
      line_right = "<C-l>",
      line_down = "<C-j>",
      line_up = "<C-k>",
    },
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
}
