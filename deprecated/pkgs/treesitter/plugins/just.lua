---@type dotvim.core.plugin.PluginOption
return {
  "IndianBoy42/tree-sitter-just",
  gui = "all",
  lazy = true,
  config = function()
    require("nvim-treesitter.parsers").get_parser_configs().just = {
      install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
        use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
      },
      maintainers = { "@IndianBoy42" },
    }
  end,
}
