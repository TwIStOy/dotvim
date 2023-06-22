return {
  -- hlsearch
  {
    "kevinhwang91/nvim-hlslens",
    lazy = true,
    config = function()
      require("hlslens").setup {
        calm_down = false,
        nearest_only = false,
        nearest_float_when = "never",
      }
    end,
    keys = {
      { "*", "*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
    },
  },
}
