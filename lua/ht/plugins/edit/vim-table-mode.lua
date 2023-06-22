return {
  -- markdown table
  Use {
    "dhruvasagar/vim-table-mode",
    lazy = {
      lazy = true,
      ft = { "markdown" },
      cmd = {
        "TableModeEnable",
        "TableModeDisable",
      },
      -- todo: add keymap for markdown
    },
    functions = {
      FuncSpec("Enable table mode", function()
        vim.cmd("TableModeEnable")
      end),
      FuncSpec("Disable table mode", function()
        vim.cmd("TableModeDisable")
      end),
    },
  },
}
