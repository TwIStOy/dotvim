---@type dotvim.core.plugin.PluginOption
return {
  "TwIStOy/tree-sitter-kafel",
  gui = "all",
  lazy = true,
  config = function(plugin)
    require("nvim-treesitter.parsers").get_parser_configs().kafel = {
      install_info = {
        url = plugin.dir,
        files = { "src/parser.c" },
        branch = "main",
        use_makefile = true,
      },
      filetype = "kafel",
      maintainers = { "@TwIStOy" },
    }
  end,
}

