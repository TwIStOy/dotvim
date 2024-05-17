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
}
