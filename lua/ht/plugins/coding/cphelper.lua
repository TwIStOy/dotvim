return {
  -- for cp programming
  Use {
    "p00f/cphelper.nvim",
    lazy = {
      dependencies = "nvim-lua/plenary.nvim",
      cmd = { "CphReceive", "CphTest", "CphRetest", "CphEdit", "CphDelete" },
      keys = { { "<F9>", "<cmd>CphTest<CR>", desc = "Run cp test" } },
      init = function()
        local home = os.getenv("HOME")
        vim.g["cph#dir"] = home .. "/Projects/competitive-programming"
        vim.g["cph#lang"] = "cpp"
        vim.g["cph#rust#createjson"] = true
        vim.g["cph#cpp#compile_command"] =
          "g++ solution.cpp -std=c++20 -o cpp.out"
      end,
    },
    category = "CPHelper",
    functions = {
      FuncSpec("Receive a parsed task from browser", "CphReceive"),
      FuncSpec("Test a solutions with all cases", "CphTest"),
      FuncSpec("Test a solution with a specified case", ExecFunc("CphTest")),
      FuncSpec(
        "Retest a solution with all cases without recompiling",
        "CphRetest"
      ),
      FuncSpec(
        "Retest a solution with a specified case without recompiling",
        ExecFunc("CphRetest")
      ),
      FuncSpec("Edit/Add a test case", ExecFunc("CphEdit")),
      FuncSpec("Delete a test case", ExecFunc("CphDelete")),
    },
  },
}
