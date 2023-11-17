import { Plugin, PluginOpts } from "@core/plugin";
import { buildSimpleCommand } from "@core/types";
import { inputArgsAndExec } from "@core/vim";

const spec: PluginOpts = {
  shortUrl: "p00f/cphelper.nvim",
  lazy: {
    dependencies: ["nvim-lua/plenary.nvim"],
    cmd: ["CphReceive", "CphTest", "CphRetest", "CphEdit", "CphDelete"],
    keys: [
      {
        [1]: "<F9>",
        [2]: "<cmd>CphTest<CR>",
        desc: "Run cp test",
      },
    ],
    init: () => {
      let home = os.getenv("HOME");
      vim.g["cph#dir"] = `${home}/Projects/competitive-programming`;
      vim.g["cph#lang"] = "cpp";
      vim.g["cph#rust#createjson"] = true;
      vim.g["cph#cpp#compile_command"] =
        "g++ solution.cpp -std=c++20 -o cpp.out";
    },
  },
  extends: {
    allowInVscode: true,
    commands: [
      buildSimpleCommand("Receive a parsed task from browser", "CphReceive"),
      buildSimpleCommand("Test a solutions with all cases", "CphTest"),
      buildSimpleCommand(
        "Test a solution with a specified case",
        inputArgsAndExec("CphTest")
      ),
      buildSimpleCommand(
        "Retest a solution with all cases without recompiling",
        "CphRetest"
      ),
      buildSimpleCommand(
        "Retest a solution with a specified case without recompiling",
        inputArgsAndExec("CphRetest")
      ),
      buildSimpleCommand("Edit/Add a test case", inputArgsAndExec("CphEdit")),
      buildSimpleCommand("Delete a test case", inputArgsAndExec("CphDelete")),
    ],
  },
};

export default new Plugin(spec);
