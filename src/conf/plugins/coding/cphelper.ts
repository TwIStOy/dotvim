import { ActionGroupBuilder, Plugin, PluginOpts } from "@core/model";
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
  allowInVscode: true,
  providedActions: () => {
    const actionsGroup = new ActionGroupBuilder()
      .from("cphelper")
      .category("cphelper");

    actionsGroup.addOpts({
      id: "cphelper.receive-task",
      title: "Receive a parsed task from browser",
      callback: "CphReceive",
    });
    actionsGroup.addOpts({
      id: "cphelper.run-all-cases",
      title: "Test a solutions with all cases",
      callback: "CphTest",
    });
    actionsGroup.addOpts({
      id: "cphelper.run-specified-case",
      title: "Test a solution with a specified case",
      callback: inputArgsAndExec("CphTest"),
    });
    actionsGroup.addOpts({
      id: "cphelper.retest-all-cases",
      title: "Retest a solution with all cases without recompiling",
      callback: "CphRetest",
    });
    actionsGroup.addOpts({
      id: "cphelper.retest-specified-case",
      title: "Retest a solution with a specified case without recompiling",
      callback: inputArgsAndExec("CphRetest"),
    });
    actionsGroup.addOpts({
      id: "cphelper.edit-task",
      title: "Edit/Add a test case",
      callback: inputArgsAndExec("CphEdit"),
    });
    actionsGroup.addOpts({
      id: "cphelper.delete-task",
      title: "Delete a test case",
      callback: inputArgsAndExec("CphDelete"),
    });

    return actionsGroup.build();
  },
};

export default new Plugin(spec);
