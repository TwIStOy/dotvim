---@type dotvim.core.plugin.PluginOption
return {
  "sindrets/diffview.nvim",
  cmd = "DiffviewOpen",
  opts = {
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
  actions = function()
    ---@type dotvim.core.action
    local action = require("dotvim.core.action")

    local actions = {
      {
        id = "diffview.open",
        title = "Open diffview",
        callback = "DiffviewOpen",
      },
      {
        id = "diffview.close",
        title = "Close the current diffview. You can also use :tabclose.",
        callback = "DiffviewClose",
      },
      {
        id = "diffview.toggle",
        title = "Toggle the file panel.",
        callback = "DiffviewToggleFiles",
      },
      {
        id = "diffview.focus",
        title = "Bring focus to the file panel.",
        callback = "DiffviewFocusFiles",
      },
      {
        id = "diffview.refresh",
        title = "Update stats and entries in the file list of the current Diffview.",
        callback = "DiffviewRefresh",
      },
    }

    return action.make_options {
      from = "diffview.nvim",
      category = "diffview",
      actions = actions,
    }
  end,
}
