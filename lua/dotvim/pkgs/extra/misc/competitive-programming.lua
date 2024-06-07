---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.competitive-programming",
  plugins = {
    {
      "p00f/cphelper.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = { "CphReceive", "CphTest", "CphRetest", "CphEdit", "CphDelete" },
      init = function()
        local home = os.getenv("HOME")
        vim.g["cph#dir"] = home .. "/Projects/competitive-programming"
        vim.g["cph#lang"] = "cpp"
        vim.g["cph#rust#createjson"] = true
        vim.g["cph#cpp#compile_command"] =
          "g++ solution.cpp -std=c++20 -o cpp.out"
      end,
      actions = function()
        ---@type dotvim.core
        local Core = require("dotvim.core")

        return Core.action.make_options {
          from = "cphelper.nvim",
          category = "cphelper",
          actions = {
            {
              id = "cphelper.receive-task",
              title = "Receive a parsed task from browser",
              callback = "CphReceive",
            },
            {
              id = "cphelper.run-all-cases",
              title = "Test a solutions with all cases",
              callback = "CphTest",
            },
            {
              id = "cphelper.run-specified-case",
              title = "Test a solution with a specified case",
              callback = Core.input_then_exec("CphTest"),
            },
            {
              id = "cphelper.retest-all-cases",
              title = "Retest a solution with all cases without recompiling",
              callback = "CphRetest",
            },
            {
              id = "cphelper.retest-specified-case",
              title = "Retest a solution with a specified case without recompiling",
              callback = Core.input_then_exec("CphRetest"),
            },
            {
              id = "cphelper.edit-task",
              title = "Edit/Add a test case",
              callback = Core.input_then_exec("CphEdit"),
            },
            {
              id = "cphelper.delete-task",
              title = "Delete a test case",
              callback = Core.input_then_exec("CphDelete"),
            },
          },
        }
      end,
    },
  },
}
