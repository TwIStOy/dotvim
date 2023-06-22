return {
  -- session management
  Use {
    "jedrzejboczar/possession.nvim",
    lazy = {
      cmd = {
        "SSave",
        "SLoad",
        "SDelete",
        "SList",
      },
      dependencies = { "nvim-lua/plenary.nvim" },
      lazy = true,
      opts = {
        silent = true,
        commands = {
          save = "SSave",
          load = "SLoad",
          delete = "SDelete",
          list = "SList",
        },
      },
    },
    functions = {
      FuncSpec("Save session", "SSave"),
      FuncSpec("Load session", "SLoad"),
      FuncSpec("Delete session", "SDelete"),
      FuncSpec("List sessions", "SList"),
    },
  },
}
