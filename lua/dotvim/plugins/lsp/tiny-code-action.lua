---@type LazyPluginSpec
return {
  "rachartier/tiny-code-action.nvim",
  event = "LspAttach",
  opts = {
    backend = "difftastic",
    picker = "snacks",
  },
}
