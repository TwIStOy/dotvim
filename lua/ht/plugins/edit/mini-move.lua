return {
  {
    "echasnovski/mini.move",
    allow_in_vscode = true,
    keys = {
      { "<C-h>", nil, mode = { "n", "v" } },
      { "<C-j>", nil, mode = { "n", "v" } },
      { "<C-k>", nil, mode = { "n", "v" } },
      { "<C-l>", nil, mode = { "n", "v" } },
    },
    opts = {
      mappings = {
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",
        line_left = "<C-h>",
        line_right = "<C-l>",
        line_down = "<C-j>",
        line_up = "<C-k>",
      },
    },
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
}
