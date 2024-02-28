---@type dora.core.plugin.PluginOption
return {
  "altermo/ultimate-autopair.nvim",
  gui = "all",
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  opts = {
    close = {
      map = "<C-0>",
      cmap = "<C-0>",
    },
    tabout = {
      hopout = true,
    },
    fastwarp = {
      enable = true,
      map = "<C-=>",
      rmap = "<C-->",
      cmap = "<C-=>",
      crmap = "<C-->",
      enable_normal = true,
      enable_reverse = true,
      hopout = false,
      multiline = true,
      nocursormove = true,
      no_nothing_if_fail = false,
    },
    config_internal_pairs = {
      {
        "'",
        "'",
        suround = true,
        cond = function(fn)
          return not fn.in_lisp() or fn.in_string()
        end,
        alpha = true,
        nft = { "tex", "rust" },
        multiline = false,
      },
    },
  },
}
