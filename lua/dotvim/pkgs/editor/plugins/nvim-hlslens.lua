---@type dotvim.core.plugin.PluginOption
return {
  "kevinhwang91/nvim-hlslens",
  opts = {
    calm_down = false,
    nearest_only = false,
    nearest_float_when = "never",
  },
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
}
