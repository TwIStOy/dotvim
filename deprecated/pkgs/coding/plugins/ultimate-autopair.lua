---@type dotvim.core.plugin.PluginOption
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
        '"',
        '"',
        suround = true,
        cond = function(fn, o)
          -- vim
          if
            fn.get_ft() == "vim"
            and (
              o.line:sub(1, o.col - 1):match("^%s*$") ~= nil
              or o.line:sub(o.col - 1, o.col - 1) == "@"
            )
          then
            return false
          end

          -- luasnip-snippets expands `#"` in cpp
          if
            fn.get_ft() == "cpp"
            and o.line:sub(1, o.col - 1):match("^%s*#$") ~= nil
          then
            return false
          end

          return true
        end,
        multiline = false,
      },
    },
  },
}
