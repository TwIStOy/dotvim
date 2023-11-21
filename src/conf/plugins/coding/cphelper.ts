import { ActionGroupBuilder, Plugin, fixPluginOpts } from "@core/model";
import { inputArgsAndExec } from "@core/vim";

let actionsGroup = new ActionGroupBuilder()
  .from("cphelper")
  .category("cphelper")
  .addOpts({
    id: "cphelper.receive-task",
    title: "Receive a parsed task from browser",
    callback: "CphReceive",
  })
  .addOpts({
    id: "cphelper.run-all-cases",
    title: "Test a solutions with all cases",
    callback: "CphTest",
  })
  .addOpts({
    id: "cphelper.run-specified-case",
    title: "Test a solution with a specified case",
    callback: inputArgsAndExec("CphTest"),
  })
  .addOpts({
    id: "cphelper.retest-all-cases",
    title: "Retest a solution with all cases without recompiling",
    callback: "CphRetest",
  })
  .addOpts({
    id: "cphelper.retest-specified-case",
    title: "Retest a solution with a specified case without recompiling",
    callback: inputArgsAndExec("CphRetest"),
  })
  .addOpts({
    id: "cphelper.edit-task",
    title: "Edit/Add a test case",
    callback: inputArgsAndExec("CphEdit"),
  })
  .addOpts({
    id: "cphelper.delete-task",
    title: "Delete a test case",
    callback: inputArgsAndExec("CphDelete"),
  });

const spec = {
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
  allowInVscode: true,
  providedActions: actionsGroup.build(),
};

export const plugin = new Plugin(fixPluginOpts(spec));
