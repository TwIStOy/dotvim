---@type dotvim.core.plugin.PluginOption
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  cmd = {
    "GitConflictChooseOurs",
    "GitConflictChooseTheirs",
    "GitConflictChooseBoth",
    "GitConflictChooseNone",
    "GitConflictNextConflict",
    "GitConflictPrevConflict",
    "GitConflictListQf",
  },
  opts = {
    default_mappings = false,
    disable_diagnostics = true,
  },
  actions = function()
    ---@type dotvim.core.action
    local action = require("dotvim.core.action")

    local actions = {
      {
        id = "git-conflict.choose-ours",
        title = "Choose ours",
        callback = "GitConflictChooseOurs",
      },
      {
        id = "git-conflict.choose-theirs",
        title = "Choose theirs",
        callback = "GitConflictChooseTheirs",
      },
      {
        id = "git-conflict.choose-both",
        title = "Choose both",
        callback = "GitConflictChooseBoth",
      },
      {
        id = "git-conflict.choose-none",
        title = "Choose none",
        callback = "GitConflictChooseNone",
      },
      {
        id = "git-conflict.next-conflict",
        title = "Next conflict",
        callback = "GitConflictNextConflict",
      },
      {
        id = "git-conflict.prev-conflict",
        title = "Previous conflict",
        callback = "GitConflictPrevConflict",
      },
      {
        id = "git-conflict.list-qf",
        title = "List quickfix",
        callback = "GitConflictListQf",
      },
    }

    return action.make_options {
      from = "git-conflict.nvim",
      category = "git-conflict",
      actions = actions,
    }
  end,
}
