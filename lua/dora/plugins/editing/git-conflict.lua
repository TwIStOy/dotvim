local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "akinsho/git-conflict.nvim",
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
  gui = "all",
  actions = lib.plugin.action.make_options {
    from = "git-conflict.nvim",
    category = "GitConflict",
    ---@param buffer dora.lib.vim.Buffer
    condition = function(buffer)
      return lib.fs.in_git_repo(buffer)
    end,
    ---@type dora.lib.ActionOptions[]
    actions = {
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
    },
  },
}
