local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "sindrets/diffview.nvim",
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
  actions = lib.plugin.action.make_options {
    from = "diffview.nvim",
    category = "Diffview",
    ---@param buffer dora.lib.vim.Buffer
    condition = function(buffer)
      -- TODO(Hawtian Wang): check if file in gitignore
      return lib.fs.in_git_repo(buffer)
    end,
    ---@type dora.lib.ActionOptions[]
    actions = {
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
    },
  },
}
