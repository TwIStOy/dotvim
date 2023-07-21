return {
  -- resolve git conflict
  Use {
    "akinsho/git-conflict.nvim",
    lazy = {
      lazy = true,
      config = true,
      opts = {
        default_mappings = false,
      },
      cmd = {
        "GitConflictChooseOurs",
        "GitConflictChooseTheirs",
        "GitConflictChooseBoth",
        "GitConflictChooseNone",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
      },
    },
    category = "GitConflict",
    functions = {
      {
        filter = {
          filter = require("ht.core.const").not_in_common_excluded,
        },
        values = {
          FuncSpec("Select the current changes", "GitConflictChooseOurs"),
          FuncSpec("Select the incoming changes", "GitConflictChooseTheirs"),
          FuncSpec("Select both changes", "GitConflictChooseBoth"),
          FuncSpec("Select none of the changes", "GitConflictChooseNone"),
          FuncSpec("Move to the next conflict", "GitConflictNextConflict"),
          FuncSpec("Move to the previous conflict", "GitConflictPrevConflict"),
        },
      },
    },
  },
}
