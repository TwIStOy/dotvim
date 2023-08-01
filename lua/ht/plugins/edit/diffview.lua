return {
  Use {
    "sindrets/diffview.nvim",
    lazy = {
      cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
      },
      config = true,
      opts = {
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      },
    },
    category = "Diffview",
    functions = {
      {
        filter = {
          filter = function(buffer)
            return require("ht.utils.fs").in_git_repo(buffer)
              and require("ht.core.const").not_in_common_excluded(buffer)
          end,
        },
        values = {
          FuncSpec("Open diffview", ExecFunc("DiffviewOpen")),
          FuncSpec(
            "Close the current diffview. You can also use :tabclose.",
            "DiffviewClose"
          ),
          FuncSpec("Toggle the file panel.", "DiffviewToggleFiles"),
          FuncSpec("Bring focus to the file panel.", "DiffviewFocusFiles"),
          FuncSpec(
            "Update stats and entries in the file list of the current Diffview.",
            "DiffviewRefresh"
          ),
        },
      },
    },
  },
}
