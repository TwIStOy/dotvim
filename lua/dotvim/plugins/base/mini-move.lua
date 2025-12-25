---@type LazyPluginSpec
return {
  "echasnovski/mini.move",
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
  keys = {
    { "<C-h>", mode = { "n", "v" } },
    { "<C-j>", mode = { "n", "v" } },
    { "<C-k>", mode = { "n", "v" } },
    { "<C-l>", mode = { "n", "v" } },
  },
}
